class Driver
	@@count_driver = 1
	attr_accessor :name
	attr_accessor :coordinate

	def initialize(*args)
		@name = "Gojek#{@@count_driver}"
		@@count_driver +=1
		if(args.size==2)
			@coordinate = [args[0],args[1]]
		else
			@coordinate =2.times.map{Random.rand(1..args[0])}
		end
	end
end