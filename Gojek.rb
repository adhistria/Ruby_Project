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
		elsif args.size==1
			table = CSV.open("gojek.csv",:headers => true,:col_sep => ";") 
			table.each do |row|
				@map = row[0].split(",")
				puts @map
				user_coor = row[1].split(",").map(&:to_i)
				puts user_coor
				@user = User.new(user_coor[0],user_coor[1])
				puts @user.coordinate[0]
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
		min = range_distance(@user.coordinate,@driver[0].coordinate)
		index_min = 0
		number_of_driver = @driver.size
		for i in 1..number_of_driver-1
			distance = range_distance(@user.coordinate,@driver[i].coordinate)
			if(distance<min)
				min= distance
				index_min = i
				puts i
			end
		end
		index_min
	end	

	def range_distance(user,driver)
		puts "new"
		puts driver[0]
		puts user[0][0]
		x_dist =  (driver[0] - user[0]).abs
		y_dist = (driver[1] - user[1]).abs
		min = (x_dist + y_dist).abs
		puts min
		min
	end

	def route_go_ride(x_destination , y_destination)
		index_near_gojek = nearest_gojek
		puts "start at (#{@user.coordinate[0]},#{@user.coordinate[1]})"
		bool =true
		count = 0
		while(bool==true)			
			direction = ""
			if(@user.coordinate[0]>x_destination)
				@user.coordinate[0]-=1
				puts "go to (#{@user.coordinate[0]},#{@user.coordinate[1]})"
				next_direction = "go straight ahead"
			elsif (@user.coordinate[0]<x_destination)
				@user.coordinate[0]-=1
				puts "go to (#{@user.coordinate[0]},#{@user.coordinate[1]})"
				next_direction = "go straight ahead"
			elsif (@user.coordinate[1]<y_destination)
				@user.coordinate[1]+=1
				puts "go to (#{@user.coordinate[0]},#{@user.coordinate[1]})"
				next_direction = "turn right"
			elsif (@user.coordinate[1]>y_destination)
				@user.coordinate[1]-=1
				puts "go to (#{@user.coordinate[0]},#{@user.coordinate[1]})"
				next_direction =  "turn left"
			end
			if next_direction == direction
				next_direction = "go straight ahead"
			end
			puts next_direction
			
			if @user.coordinate[0]==x_destination and @user.coordinate[1]==y_destination
				puts "finish at (#{x_destination},#{y_destination})"
				bool =false
			end
			count+=1
			# puts direction= next_direction
		end
	end

	def order_go_ride
		puts "Order Go Rider"
		count = 0
		bool = true
		while(bool)
			if count > 0
				puts "Wrong Input"
			end
			puts "Input your destination coordinate : ex '2,4' "
			coordinate = gets.chomp	
			coordinate = coordinate.split(",")
			if(coordinate[0] !~ /\D/  and coordinate[1] !~ /\D/  )
				x_coor = Integer(coordinate[0])
				y_coor = Integer(coordinate[1])
				bool = false
			end	
			count+=1
		end
		index_near_gojek = nearest_gojek(x_coor,y_coor)
		total_cost = calculate_cost(x_coor,y_coor)
		order = confirm_order
		if(order=="no")
			puts "Tidak Jadi Pesan"
			# back ke menu utama
		else
			route_go_ride(x_coor,y_coor)
			@driver[index_near_gojek].coordinate = [x_coor,y_coor]
		end
	end

	def calculate_cost(x_destination,y_destination)
		x_start = @user.coordinate[0]
		y_start = @user.coordinate[1]
		count = 0
		bool= true
		while(bool==true)			
			if(x_start>x_destination)
				x_start-=1
			elsif (x_start<x_destination)
				x_start-=1
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
		puts "total cost = #{count*300} "
	end

	def confirm_order
		print "Confirm Order ? (yes or no)"
		bool = gets.chomp.downcase
		puts bool.class
		until (bool == ("yes") or bool ==("no"))
			puts "Confirm Order ? (yes or no)"
			bool = gets.chomp.downcase
		end
		bool
	end
end

# def gocli(*args)
	
# 	if args.size==0
# 		gojek = Gojek.new
# 	elsif args.size==1
# 		gojek = Gojek.new(args[0])
# 		# gojek.nearest_gojek
# 		# gojek.confirm_order
# 		# gojek.calculate_cost(9,19)
# 		# gojek.order_go_ride(9,19)
# 		gojek.order_go_ride
# 	elsif args.size==3
# 		gojek = Gojek.new(args[0],args[1],args[2])
# 		# gojek.driver[0].name
# 		puts gojek.driver[0]
# 	end
# end


# show_map
# buat kelas driver, beri nama driver, destinasi, 
# buat kelas user
# gocli("gojek.csv")
# gocli(10,20,30)
# File.foreach("path/to/file") { |line|  }
# File.read 'gojek.txt'
# CSV.parse('gojek.csv')
# headers = CSV.read("gojek.csv", headers: true).headers
  # table = CSV.open("gojek.csv", :headers => true)
  # puts table.headers
  # # => true
  # puts table.read
  # => #<CSV::Table mode:col_or_row row_count:2>
# puts headers
# table = CSV.open("gojek.csv",:headers => true,:col_sep => ";") 
# puts table.read
# table.each {|row| puts row['map_size']}
# puts table.row[0]

# # end
# CSV.foreach('gojek.csv', :headers => true) do |row|
#   puts row['map_size'] # prints 1 the 1st time, "blah" 2nd time, etc
#   # puts row['user_coordinate'] # prints 2 the first time, 7 the 2nd time, etc
#   # puts row['number_of_drivers']
# end
# file = open('gojek.txt')
# puts file[0]
# gojek =Gojek.new(10,10,10)
# puts gojek.user