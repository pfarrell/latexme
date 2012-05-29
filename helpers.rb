%w(gmail mail uri pathname).each { |dependency| require dependency }

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
      if(attachment.filename =~ /\.tex$/)
        path = "tmp/" + emailid 
        filename = File.basename(attachment.filename, ".tex")
        file = File.new(path + "/" + attachment.filename, "w+")
        file << attachment.decoded
        file.close
        system("pdflatex -interaction nonstopmode --output-directory " + path + " " + attachment.filename)
        mail(email.from, 'RE: ' + email.subject, "Here's your file", path + "/" + filename + ".pdf")
      end
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

def mail(email_to, email_subject, email_text, attachment_path)

  yml = YAML::load(File.open('config/config.rb'))
  gmail = Gmail.new(yml['gmail']['username'], yml['gmail']['password']) do |gmail|
    gmail.deliver do
      to email_to
      subject email_subject
      text_part do
        body email_text
      end
      add_file File.expand_path(attachment_path)
    end
  end
end
