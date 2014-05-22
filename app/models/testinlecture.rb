class Testinlecture
  include Mongoid::Document
  
  field :active, type: Boolean
  
  belongs_to :test
  belongs_to :lecture
  has_many :scores
  
  def change_visibility
  	if (self.active)
  		self.active = false
  	else
  		self.active = true
  	end
  	if self.save
  		true
  	else
  		false
  	end
  end
    
  def update_score(test,testinlecture, answer,score,member,answers)
    logger.debug(test)
    logger.debug(testinlecture)
    logger.debug(answer)
    logger.debug(score)
    logger.debug(member)
    logger.debug(answers)
   if !test.multianswer
     logger.debug("es single")
     if test.answers.to_a[0].id.to_s == answer.to_s
       logger.debug("es correcta")
        if score.empty?      
          empty = true
          score = Score.new(:testinlecture => testinlecture ,:member => member,:attempt => 1,:score => 10,:status => "close")   
          member.grade = (member.grade +  score.score) 
        else
          score = score[0]
          empty = false
          score.status="close"
          score.attempt = score.attempt + 1
          score.score = 1
          if score.attempt == 2 
            score.score = 6 
          elsif score.attempt == 3 
            score.score = 3 
          else
            score.score = 1 
          end     
          member.grade = (member.grade + score.score)
        end
      else
       logger.debug("es incorrecta")
        if score.empty?
          empty = true
          score = Score.new(:testinlecture => testinlecture ,:member => member,:attempt => 1,:score => 0,:status => "open")   
        else
          empty = false
          score = score[0]
          if score.attempt == 3      
            score.status="close"
              member.grade = (member.grade + score.score) 
          else
             score.attempt =  score.attempt + 1
          end   
        end  
      end
   else
    logger.debug("es multi")
    correct = Array.new
    test.answers.where(valid: true).to_a.each do |cor|
      correct << cor.id.to_s
    end  
    max = test.answers.to_a.count
    result = 0
    fails = 0
    test.answers.each do |answer|
      if answers.to_a.include?(answer.id.to_s)
        if answer.valid==true
          result = result + 1
        else
          fails = fails + 1
        end  
      else
        if answer.valid==false
           result = result + 1
        else
          fails = fails + 1
        end  
      end     
    end 
    value = ((result * 10 / max).to_f.round(2) ) - (((fails * 10) / (max * 4)).to_f.round(2) )
    logger.debug(value)
    member.grade = (member.grade + value) 
    score = Score.new(:testinlecture => testinlecture ,:member => member,:attempt => 1,:score => value,:status => "close") 
   end  
    logger.debug(score)
     if empty
         if score.save and member.update
            {:score => score}
         else
            {:score => false}
         end
     else      
         if  score.update and member.update
           {:score => score,:correct =>correct}
         else
           {:score => false,:correct=>correct}
        end
      end
  end
end