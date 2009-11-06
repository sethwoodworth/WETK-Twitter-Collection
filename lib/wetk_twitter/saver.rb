# Variations within the saver class:
# - Type of object being saved (tweets, userinfo, followers, followees)
# - Which tag(s) to use 
# - Whether to save, update, or not save 
# 
# Similarities within the saver class: 
# - all recieve an object
# - all receive a rule set
# - 

class Saver
  def initialize(rules)
    @rules = rules
  
  end
end