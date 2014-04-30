f = open('|gem list')
output = f.read()
 
output.each_line do |l|
	gem_name = l.split(" ").first
	system "gem uninstall --a --ignore-dependencies #{gem_name}"
end
