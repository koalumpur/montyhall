class Door 
  attr_reader :item, :is_open 

  def initialize(item)
    @item = item
    @is_open = false
  end

  def open
    @is_open = true
  end

  
end  


class Experiment
  attr_reader :doors
  ITEMS = [:car, :goat, :goat]
  STATES = [:initialized, :one_door_opened, :finished]

  def initialize
    @doors = ITEMS.shuffle.map { |item| Door.new(item) }
    @state = STATES[0]
  end

  def first_select(selected_door_index)
    return if @state != STATES[0]
    @selected_door_index = selected_door_index
    goat_door = @doors.find.with_index {|door, index| door.item == :goat && index != selected_door_index}
    goat_door.open
    @state = STATES[1]
    goat_door
  end  

  def second_select(door_changed)
    return if @state != STATES[1]
    if door_changed
      chosen_door = @doors.find.with_index {|door, index| index != @selected_door_index && !door.is_open}
      @selected_door_index = @doors.find_index(chosen_door)
    else
      chosen_door = @doors[@selected_door_index]
    end
    chosen_door.open
    @state = STATES[2]
  end  

  def victory?
    return if @state != STATES[2]
    @doors[@selected_door_index].item == :car   
  end  

  def self.run
    puts("Let's start a Monty-Hall experiment, shall we?")
    puts("There are three doors in front of you. Behind each door you might find either a car or a goat. There are two doors with a goat behind them. Please, choose which one you would like to open.")
    door1 = gets.chomp
    return if !('1'..'3').include? door1
    a = self.new
    puts("You selected door number", door1) 
    open_door = a.first_select(door1.to_i - 1)
    puts("Goat behind door number ", a.doors.index(open_door)+1)
    puts("Wanna change your choice? Y/N")
    door_changed = gets.chomp
    return if !['Y', 'N'].include? door_changed
    a.second_select(door_changed == 'Y') 
    if a.victory? 
      puts('You woooooooon!')
    else 
      puts('Sorry, mate, try another time!')
    end 
  end   

end



