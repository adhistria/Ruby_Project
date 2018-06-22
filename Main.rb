require_relative 'Gojek'
require 'pathname'

class Main
	def gocli(*args)
		if args.size==0
			gojek = Gojek.new
			gojek.menu
		elsif args.size==1
			gojek = Gojek.new(args[0])
			gojek.order_go_ride
		elsif args.size==3
			gojek = Gojek.new(args[0],args[1],args[2])
		end
	end

	def home_page
	 	i= 1
		puts "Welcome To GoCli, Type quit to exit from GoCli"
		syntax = ""
		while syntax!="quit"
			print "2.5.0 :00#{i} > "
			syntax = gets.chomp.downcase
			# case if go cli or quit or help, if not, give direct to help
			if syntax == "gocli"
				self.gocli
				# gocli.menu
			   # self.gocli
			   # puts "Welcome To GoCli"
			elsif syntax.include? "gocli"
				syntax.slice! "gocli"
				if(syntax.index('(')==0 and syntax.count("(") ==1 and syntax.count(")")==1)
					syntax.slice! "("
					syntax.slice! ")"
					syntax.gsub! /"/, ''
					syntax.gsub! /'/, ''
					if(syntax.include? ".csv")
						if(File.exist?(syntax)) 
							  self.gocli(syntax)
							  puts "Welcome To GoCli"
							else 
							  puts '#{syntax} or directory exists'
							end
					elsif(syntax.include? ",")
						new_syntax = syntax.split ","
						if(new_syntax.size==3)
							if new_syntax[0] !~ /\D/  and new_syntax[1] !~ /\D/  and new_syntax[2] !~ /\D/
								n = Integer(syntax[0])
								x = Integer(syntax[1])
								y = Integer(syntax[2])
								self.gocli(n,x,y)
								puts "Welcome To GoCli"
							end
						else
							puts "Wrong Input"
						end
					else
						puts "Wrong Input"
					end
				end
			elsif syntax == "help"
				puts "To Run Go Cli"
				puts "-- gocli without paramater"
				puts "-- gocli(file_name.csv) with csv file_name parameter"
				puts "-- gocli(10,20,30) with 3 numbers as params  "
				puts "-- quit to Exit"
			elsif syntax=="quit"
				puts "Bye bye" 
			else
				puts "Wrong Input, Check -- help"
			end	
			i+=1
		end
	end
	
end


main = Main.new

main.home_page
