class Driver
	@@count_driver = 1
	attr_accessor :name
	attr_accessor :coordinate
	private :name
	private :coordinate
	def initialize(*args)
		@name = "Gojek#{@@count_driver}"
		@@count_driver +=1
		if(args.size==2)
			@coordinate = [args[0],args[1]]
		else
			@coordinate =2.times.map{Random.rand(1..args[0])}
		end
	end
	def get_name
		@name
	end

	def get_coordinate
		@coordinate
	end

	def set_coordinate(x,y)
		@coordinate = [x,y]
	end
end