class User
	attr_accessor :name
	attr_accessor :coordinate
	attr_accessor :history
	private :name
	private :coordinate
	private :history

	def initialize(*args)
		@name = "User"
		@count_history = 1
		if(args.size == 2)
			@coordinate = [args[0],args[1]]
		else
			@coordinate = 2.times.map{Random.rand(1..args[0])}
		end
		@history = File.open('History.txt', 'w') {|file| file.truncate(0) }
	end

	def save_history(histories)
		if(@count_history==1)
			File.new("History.txt")
		end
		File.open("History.txt", "a+") {|f| f.puts("History #{@count_history}")}
		File.open("History.txt", "a+") do |f|
			histories.each { |history| f.puts(history) }
		end	
		@count_history+=1
		File.open("History.txt", "a+") {|f| f.puts("")}
	end

	def show_history
		puts `clear`
		if(File.read("History.txt")=="")
			puts "No History"
		else
			File.open("History.txt", "r") do |f|
			  f.each_line do |line|
			    puts line
			  end
			end			
		end
	end

	def get_name
		@name
	end

	def get_coordinate
		@coordinate
	end

	# def 
end