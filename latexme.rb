%w(yaml gmail ./helpers).each { |dependency| require dependency }

yml = YAML::load(File.open('config/config.rb'))

mkdir!("tmp")

gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
  inbox = gmail.inbox
  inbox.emails(:unread).each do |email|
    process!(email)
  end
end

