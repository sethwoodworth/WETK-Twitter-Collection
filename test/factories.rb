Factory.define :saver do |s|
  s.rules {}
end

Factory.define :tweet do |t|
    t.text "Someting to tweet about"
    t.from_user "aplusk"
    t.status_id 3982929       
end
