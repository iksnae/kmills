module(..., package.seeall)

-- simple string splitter

function splitString(str, c)
	a = string.find(str,c)
	str = string.gsub(str,c,"",1)
	aCount=0
	start=1
	array={}
	last=0;
	while a do
		array[aCount] = string.sub(str, start, a-1)
		start = a
		a = string.find(str,c)
		str = string.gsub(str,c,"",1)
		aCount=aCount+1
		end
	return array
end


local function levelLoadListener( event )
	if( event.isError) then 
		print("error loading level!");
	else
		print("level loaded.")
	end
	print("Response: "..event.response)
end


function loadLevel(url)
	network.download(url,"GET",levelLoadListener)
end