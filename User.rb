class User
	attr_accessor :name
	attr_accessor :coordinate
	attr_accessor :history
	def initialize(*args)
		@name = "User"
		if(args.size == 2)
			@coordinate = [args[0],args[1]]
		else
			@coordinate = 2.times.map{Random.rand(1..args[0])}
		end
	end
	# def initialize(n)
	# 	@name = "User"
		
	# 	@history = []
	# end
	# def initialize(x,y)
	# 	@name = "User"
		
	# end
	# def calculate_cost(x_destination,y_destination)
	# 	x_start = @coordinate[0]
	# 	y_start = @coordinate[1]
	# 	count = 0
	# 	bool= true
	# 	while(bool==true)			
	# 		if(x_start>x_destination)
	# 			x_start-=1
	# 		elsif (x_start<x_destination)
	# 			x_start-=1
	# 		elsif (@user[1]<y_destination)
	# 			y_start+=1
	# 		elsif (@user[1]>y_destination)
	# 			y_start-=1
	# 		end			
	# 		if x_start==x_destination and y_start==y_destination
	# 			bool =false
	# 		end
	# 		count+=1
	# 	end
	# 	puts "total cost = #{count*300} "
	# end
	# def confirm_order
	# 	print "Confirm Order ? (yes or no)"
	# 	bool = gets.chomp.downcase
	# 	puts bool.class
	# 	until (bool == ("yes") or bool ==("no"))
	# 		puts "Confirm Order ? (yes or no)"
	# 		bool = gets.chomp.downcase
	# 	end
	# 	if(bool== "yes" )
	# 		# show route after this metho
	# 		num = 1
	# 	else
	# 		puts "Gak jadi pesen gojek"
	# 	end
	# end
end