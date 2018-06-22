require 'csv'
require_relative 'Driver'
require_relative 'User'
class Gojek
	attr_accessor :map
	attr_accessor :driver
	attr_accessor :user

	def initialize(*args)
		if(args.size == 3)
			@map = [args[0],args[0]]
			@driver = []
			# @driver = self.create_driver(args[0])
			@driver = self.create_random_driver(args[0])
			@user = User.new(args[1],args[2])
		elsif args.size==0
			@map =[20,20]
			@driver = create_random_driver(20)
			@user = User.new(20)
			puts @user.get_name
		elsif args.size==1
			table = CSV.open("gojek.csv",:headers => true,:col_sep => ";") 
			table.each do |row|
				@map = row[0].split(",")
				puts @map
				user_coor = row[1].split(",").map(&:to_i)
				puts user_coor
				@user = User.new(user_coor[0],user_coor[1])
				puts @user.get_coordinate[0]
				string_driver_coor = row[3].split("-")
				@driver = []
			 	string_driver_coor.each do |x| 
			 		driver_coor = x.split(",").map(&:to_i) 
			 		self.add_driver(driver_coor[0],driver_coor[1])
			 	end
	 		end
		end
	end

	def create_random_driver(n)	
		new_driver = []
		for i in 0..4
			new_driver.push(Driver.new(n))
		end
		new_driver
	end

	def add_driver(x,y)
		@driver.push(Driver.new(x,y))
	end		

	def nearest_gojek
		min = range_distance(@user.get_coordinate,@driver[0].get_coordinate)
		index_min = 0
		number_of_driver = @driver.size
		for i in 1..number_of_driver-1
			distance = range_distance(@user.get_coordinate,@driver[i].get_coordinate)
			if(distance<min)
				min= distance
				index_min = i
			end
		end
		index_min
	end	

	def range_distance(user,driver)
		x_dist =  (driver[0] - user[0]).abs
		y_dist = (driver[1] - user[1]).abs
		min = (x_dist + y_dist).abs
		min
	end

	def route_go_ride(x_destination , y_destination)
		array_route = []
		puts "=========================="
		puts "=====Start Navigation====="
		index_near_gojek = nearest_gojek
		array_route.push("start at (#{@user.get_coordinate[0]},#{@user.get_coordinate[1]})")
		puts "start at (#{@user.get_coordinate[0]},#{@user.get_coordinate[1]})"
		bool =true
		direction = ""
		while(bool==true)			
			if(@user.get_coordinate[0]>x_destination)
				@user.get_coordinate[0]-=1
				next_direction = "go straight ahead"
			elsif (@user.get_coordinate[0]<x_destination)
				@user.get_coordinate[0]+=1
				next_direction = "go straight ahead"
			elsif (@user.get_coordinate[1]<y_destination)
				@user.get_coordinate[1]+=1
				next_direction = "turn right"
			elsif (@user.get_coordinate[1]>y_destination)
				@user.get_coordinate[1]-=1
				next_direction =  "turn left"
			end			
			if next_direction == direction
				next_direction = "go straight ahead"
			else
				direction = next_direction
			end
			puts "go to (#{@user.get_coordinate[0]},#{@user.get_coordinate[1]})"
			puts next_direction
			array_route.push(next_direction)
			array_route.push("go to (#{@user.get_coordinate[0]},#{@user.get_coordinate[1]})")
			if @user.get_coordinate[0]==x_destination and @user.get_coordinate[1]==y_destination
				puts "finish at (#{x_destination},#{y_destination})"
				array_route.push("finish at (#{x_destination},#{y_destination})")
				bool =false
			end
		end
		array_route
	end

	def order_go_ride
		bool= true
		# while bool
		array_of_history = []
		puts `clear`
		puts "===================================="
		puts "===========Order Go Ride============ "
		count = 0
		bool = true
		while(bool)
			if count > 0
				puts "Wrong Input"
			end
			puts "Input your destination coordinate : ex '2,4'"
			puts "The longest coordinate : (#{@map[0]},#{@map[0]})"
			print "Coordinate : "
			coordinate = gets.chomp	
			coordinate = coordinate.split(",")
			if(coordinate[0] !~ /\D/  and coordinate[1] !~ /\D/  )
				x_coor = Integer(coordinate[0])
				y_coor = Integer(coordinate[1])
				if(x_coor > 0 && x_coor <=@map[0]) && (y_coor > 0 && y_coor <= @map[1] )
					bool = false
				end
			end	
			count+=1
		end
		index_near_gojek = nearest_gojek
		puts "Nearest Gojek #{@driver[index_near_gojek].get_name}"

		total_cost = calculate_cost(x_coor,y_coor)
		puts total_cost
		puts "Total cost = Rp. #{total_cost}"
		order = confirm_order
		if(order=="no")
			bool = false
		else
			array_of_route = route_go_ride(x_coor,y_coor)
			array_of_history.push("Driver Name : #{@driver[index_near_gojek].get_name}")
			array_of_history.push("Price : Rp. #{total_cost}")
			array_of_history.push("Navigation")
			array_of_route.each {|x| array_of_history.push(x)}
			@user.save_history(array_of_history)
			puts "Enter To Exit"
			gets
			@driver[index_near_gojek].set_coordinate(x_coor,y_coor)
		end
	end

	def calculate_cost(x_destination,y_destination)
		x_start = @user.get_coordinate[0]
		y_start = @user.get_coordinate[1]
		count = 0
		bool= true
		while(bool)			
			if(x_start>x_destination)
				x_start-=1
			elsif (x_start<x_destination)
				x_start+=1
			elsif (y_start<y_destination)
				y_start+=1
			elsif (y_start>y_destination)
				y_start-=1
			end			
			if x_start==x_destination and y_start==y_destination
				bool =false
			end
			count+=1
		end
		total_cost = count *300
	end

	def confirm_order
		puts "Confirm Order ? (yes or no)"
		print "Confirm : "
		bool = gets.chomp.downcase
		until (bool == ("yes") or bool ==("no"))
			puts "Confirm Order ? (yes or no)"
			print "Confirm : "
			bool = gets.chomp.downcase
		end
		bool
	end

	def show_map
		bool = true
		while  bool
			puts `clear`
			puts "Show Map"
			for i in 1..@map[0]
				for j in 1..@map[1]
					if(i==@user.get_coordinate[0] && j ==@user.get_coordinate[1])
						print"X "
					else
						print"= "
					end
				end
				puts""
			end
			puts "X is your location"
			puts "Enter to Exit "
			gets
			bool = false
		end
	end

	def show_menu 
		puts `clear`
		puts "===================================="
		puts "==========Welcome To GoCli=========="
		puts "=============Main Menu=============="
		puts "=============1.Show Map============="
		puts "==========2.Order Go Ride=========="
		puts "===========3.View History==========="
		puts "==============4.Quit================"
		puts "===================================="
		print "Choose Menu : "
	end

	def show_user_histories
		@user.show_history
		puts "Enter To Exit"
		gets
	end

	def menu
		show_menu
		switch_menu = gets.chomp

		bool = true
		while bool
			if switch_menu == "1" || switch_menu == "2" || switch_menu == "3" || switch_menu == "4" 
				bool = false
			else
				puts "Wrong Input"
				print "Choose Menu : "
				new_menu = gets.chomp
				switch_menu = check_menu(new_menu)
			end


		end
		while switch_menu!= "4"
			case switch_menu
				when "1"
					puts "coba"
					self.show_map
					# self.menu
				when "2"
					self.order_go_ride
				when "3"
					self.show_user_histories
			end
			puts `clear`
			show_menu
			new_menu = gets.chomp
			switch_menu = check_menu(new_menu)
		end
	end

	def check_menu (switch_menu)
		count = 0
		while(switch_menu != "1" && switch_menu != "2" && switch_menu != "3" && switch_menu != "4" )
			if count > 1 
				puts "Wrong Input"
			end
			print "Choose Menu : "
			switch_menu = gets.chomp
			count+=1
		end
		switch_menu
	end

end