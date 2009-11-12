Factory.sequence :status_id do |n|
  "1432#{n}".to_i
end

Factory.define :tweet do |t|
    t.text "Someting to tweet about"
    t.from_user "aplusk"
    t.status_id {Factory.next(:status_id)}       
end

Factory.define :twitter_account do |tw|
    tw.screen_name "User46"
end

Factory.define :call do |c|
  c.query "User46"
  c.completed_in 32324
  c.since_id 32423
  c.max_id 34234
  c.refresh_url "www.fsadjf.com"
  c.results_per_page 100
  c.next_page 3   
  c.page 2
end

Factory.define :api do |a|
   a.domain "flskfdsa"
   a.name "afkldjsaf"
   a.description "fdljks"
   a.documentation_url "klfjsd"
   a.username "fkjlsd"
   a.password "lfksjf"
end