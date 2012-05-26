%w(gmail mail uri).each { |dependency| require dependency }

def String.random_alphanumeric(size=16)
  s = ""
  size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
  s
end

def mkdir!(directory) 
  if !FileTest::directory?(directory)
    Dir::mkdir(directory)
  end
end

def process!(email)
  begin
    emailid = String.random_alphanumeric
    mkdir!("tmp/" + emailid)

    email.attachments.each do |attachment|
      path = "tmp/" + emailid + "/" + attachement.filename
      puts attachment.inspect
      attachment.save_to_file(path)
      system("pdflatex " + path)
    end

    # here's where we'll get commands to run on doc
    #email.body.parts.each do |part|
    #  puts part.inspect
    #end

    #send_email(email, links)
  ensure
    email.mark(:read)
  end
  #links
end

def send_email(email, links) 
  begin
    mail(email.from, 'pflatex@gmail.com', 'RE: ' + email.subject, data)
  ensure
    #cleanup(links)
  end
end

def mail(email_to, email_from, email_subject, email_text)

  yml = YAML::load(File.open('config/config.rb'))

  gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
    gmail.deliver do
      to email_to
      from email_from
      subject email_subject
      text_part do
        body email_text
      end
    end
  end
end
