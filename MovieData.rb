#Rachel Burkhoff
#6/3/12
#MovieData.rb
#Takes in information from a data file called u.data stores the information and finds most popular movies
#and which movie is most similar to user 1 
#problem finding least popular movies. dont know why it doesnt work 

class MovieData
  attr_reader :allData, :orderPop, :userData
  #reads in the data from the original m;-100k files and stores them in 
  #whichever way it needs to be stored 
  def loadData 
    STDOUT.flush 
    data = File.open("uReal.data", "r") 
    
    count = 0 #counter for number of reviews 
    dataList = Array.new #array holding list of arrays (holding data of each review) 
   
    #goes through each line of data and creates an array storing all of the information and stores it in dataList
    data.each_line do |x|
      x = x.split
      dataList[count] = [x[0].to_i, x[1].to_i, x[2].to_i]
      count = count+1
    end 
    @allData = dataList 
    
    #order data based on users and what movies theyve seen 
    @userData = Array.new(1682)
    count = 1
    1682.times do
      x =0
      person = Array.new 
      
      100000.times do    
        if @allData[x][0].to_i == count
          person.push(@allData[x][1]) 
        end 
        x = x+1
      end 
      
      @userData [count-1] = person
      count = count+1 
    end 
  end

  #returns a number that indicates the popularity (higher numbers are more popular)
  def popularity (movieId)
    rates = Array.new 
    pop = Array.new 
    people = 0
    
    #finding all of the movie ratings from list of data and storing info 
    @allData.each do |x|
      if movieId == x[1]
        rates[people] = [x[2]]
        people = people +1 
      end 
    end 
    
    #gets average 
    avg =0
    rates.each do |x|
      avg = avg + x[0]
    end
    
    if people != 0 
      avg = avg/people  #avg number rating using amount of people 
    end 
    
    pop = [people, avg] 
    return people
  end

  #generates a list of all movie_id's ordered by decreasing popularity 
  def popularityList
    @orderPop= Hash.new
    movie = 1 
    
    #gets popularity for each movie and adds to list ********* MUST CHANGE THE AMOUNT movie is incremented ***********
    1682.times do
      @orderPop[movie] = popularity(movie)
      movie = movie+1 
    end 
    #sorts array by how many times a movie has been seen 
    @orderPop=Hash[@orderPop.sort_by{|k, v| -v}]

    @orderPop.keys
  end


   #generates a number which indicates the similarity in movie preference 
  #between user1 and user2 (where higher numbers indicate greater similarity)
  def similarity (x, y)
  
    xArray = Array.new 
    yArray = Array.new 
     
    #adds which movies each user has seen into seperate arrays 
    count = 0 
    @userData[x-1].each do 
      xArray.push(@userData[x-1][count])
      count= count+1
    end 
    count = 0
     @userData[y-1].each do 
      yArray.push(@userData[y-1][count])
      count= count+1
    end 

    similar =0.0
    xArray.each do |xReview|
      yArray.each do |yReview|
        #if they saw the same movie then add a counter 
        if xReview == yReview 
          similar = similar +1.0
        end 
      end 
    end 
    
    #determine similarity based on how many of the same movies they've both watched
    #gets the percentage of how many movies for each person and then averages it between the tow percentages
    prct = 0
    if similar!= 0 
      prct = ((((similar/ xArray.length) + (similar/ yArray.length) )/ 2.0)*100).round(2)
    end 
    return prct
  end 
  
  #returns a list of users whose tastes are most similar to the tastes of user u 
  def mostSimilar (x)
    count = 0
    bestPrct = 0.0
    bestUser = 0
    prct = 0.0
    comparedYet = Array.new 
    @allData.each do 
      #compare every user to x
      if (x != @allData[count][0]) & !(comparedYet.include? (@allData[count][0]))
        comparedYet.push(@allData[count][0])
        prct = similarity(x, @allData[count][0])
        #if has bigger percentage change most simmilar to the current user 
        if prct > bestPrct 
          bestPrct = prct
          bestUser = @allData[count][0]
        end 
        
      end
      count = count+1 
    end 
    puts "Most similar to user #{x} is user #{bestUser} with a similarity of #{bestPrct}%"
  end 
  
  
end 

#TEST*****
movieInfo = MovieData.new
movieInfo.loadData
ordered = movieInfo.popularityList
puts "The top 10 most and least popular movies are: "
for x in (0..1681) do 
  if x<11
    puts "#{x+1}. #{ordered[x]}"
    x = x+1
  end
  if x>1672
    puts "#{x+1}. #{ordered[x]}"
  end 
  
end 
movieInfo.mostSimilar(1)