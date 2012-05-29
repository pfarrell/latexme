%w(yaml gmail ./helpers).each { |dependency| require dependency }

yml = YAML::load(File.open('config/config.rb'))

mkdir!("tmp")

def validate_pid(file_name)
  retval = false
  if !File.exists?(file_name)
    generate_pid(file_name, $$)
    retval = true
  else
    file_pid = open(file_name).gets
    begin
      Process.kill 0, file_pid.to_i
    rescue
      generate_pid(file_name, $$)
      retval = true
    end
  end
  retval
end

def generate_pid(file_name, process_id)
  File.open(file_name, 'w+') {|f| f.write($$) }
end

if validate_pid("/tmp/latexme.pid")
  iter = -1

  while(true)
    iter = iter + 1
    gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
      gmail.inbox.emails(:unread).each do |email|
        process!(email)
      end
    end

    sleep(15)
  end
end

