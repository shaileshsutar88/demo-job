require 'net/ssh'

# put commands to send to the remote Ruby here...
CMDs = [
  '-v',
]

print 'Enter your password: '
password = gets.chomp

Net::SSH.start('localhost', ENV['USER'], :password => password) do |ssh|

  remote_ruby = ssh.exec!('/usr/bin/which ruby').chomp
  puts 'Using remote Ruby: "%s"' % remote_ruby

  CMDs.each do |cmd|

    puts 'Sending: "%s"' % cmd

    stdout = ''
    ssh.exec!("#{ remote_ruby } #{ cmd }") do |channel, stream, data|
      stdout << data if stream == :stdout
    end

    puts 'Got: %s' % stdout
    puts
  end

end
