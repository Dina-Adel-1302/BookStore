#==================================================================================================================
# Welcome to the book store program
#==================================================================================================================

class StoreItem 
    def initialize()
    end
end

#Class to store all the information of the book 
class Book < StoreItem

    attr_accessor :title, :price, :author_name, :num_pages, :isbn

     #Book.txt title,price,author name,number of pages,isbn 
    def initialize(title="", price="", author_name="", num_pages="", isbn="")
        @title = title
        @price = price
        @author_name = author_name
        @num_pages = num_pages
        @isbn = isbn
    end
    def to_s 
        return "Title: " + @title.to_s + " - Price: " + @price.to_s + " - Author: " + @author_name.to_s +
        " - Number of pages: " + @num_pages.to_s + " - ISBN: " + @isbn.to_s
    end
end

#Class to store all the information about the magazine
class Magazine < StoreItem

    attr_accessor :title, :price, :publisher_agent, :date

    #Magazine.txt #title,price,publisher-agent,date
    def initialize(title="", price="", publisher_agent="", date="")
      @title = title
      @price = price
      @publisher_agent = publisher_agent
      @date = date 
    end

    def to_s
        return "Title: " + @title.to_s + " - Price: " + @price.to_s + " - Publisher agent: " + @publisher_agent.to_s + 
                " - Date: " + @date.to_s
    end
end

#read the data of books and magazines from files, then store the data in an array of StoreItem 
def load_items
    store = []
    File.open("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Books.txt", "r") do |f|
        f.each_line do |line|
            if !line.empty? && line.to_s != ("\n")
                line_splitted = line.split(',')
                #Book.txt title,price,author name,number of pages,isbn 
                book_object = Book.new(line_splitted[0],line_splitted[1], line_splitted[2],line_splitted[3], line_splitted[4])
                store.push(book_object)
            end
        end
    end

    File.open("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Magazines.txt", "r") do |f|
        f.each_line do |line|
            if !line.empty? && line.to_s != ("\n")
                line_splitted = line.split(',')
                #Magazine.txt #title,price,publisher-agent,date
                magazine_object = Magazine.new(line_splitted[0],line_splitted[1], line_splitted[2],line_splitted[3])
                store.push(magazine_object)
            end
        end
    end
    return store
end
#----------------------------------------End load_items-------------------------------------------------------------------

#search about the magazine by publisher name
def magazineByPublisher(store,publisher_from_user)
    magazines = []
    tmp_magazine = Magazine.new()
    store.each do |item|
        if item.class.name == tmp_magazine.class.name
            if item.publisher_agent == publisher_from_user
                magazines.push(item)
            end
        end
    end
    return magazines
end
#-----------------------------------------End magazineByPublisher--------------------------------------------------------------


#append new book or magazine to the corresponding file
def write_to_file(item_info, book_or_magazine)
    if book_or_magazine == "b"
        File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Books.txt", item_info + "\n", mode: 'a')
    else
        File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Magazines.txt", item_info + "\n", mode: 'a')
    end
end
#----------------------------------------End write_to_file-----------------------------------------------------------------

#Update the files
def update_file(store)
    temp_book = Book.new()
    temp_magazine = Magazine.new()
    String books = String.new()
    String magazines = String.new()
    store.each do |item|
        if item.class.name == temp_book.class.name
            books += item.title + ',' + item.price + ',' + item.author_name + ',' + item.num_pages + ',' + item.isbn
        end 
        if item.class.name == temp_magazine.class.name
            magazines += item.title + ',' + item.price + ',' + item.publisher_agent + ',' + item.date
        end    
    end
    File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Books.txt", books)
    File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Magazines.txt", magazines)
end
#---------------------------------------------End update_file--------------------------------------------------------------------

#store all the books and magazines by price, descendingly
def sort_store_by_price(store)
    #bubble sort - O(n)
    swap = false
    while !swap do
        swap = true
        for j in (1 .. store.length-1)
            if store[j-1].price.to_i < store[j].price.to_i
                swap = false
                temp = store[j]
                store[j] = store[j-1]
                store[j-1] = temp
            end
        end 
    end
    return store
end
#-----------------------------------------End sort_store_by_price---------------------------------------------------------

#run all the operations in GUI
def run_GUI(store)
    require 'flammarion'
    
    f = Flammarion::Engraving.new
    f.puts("\t\t\t\t\t\t\t\t Welcome to the Book Store".light_white)

    #Add Store Item
    f.button("Add Store Item".yellow){
        window = Flammarion::Engraving.new
        
        window.button("Add Book".yellow){
            window_add_book =  Flammarion::Engraving.new
            window_add_book.puts("Add Book")
            # Book: Title, Price, Author name, Number of pages, ISBN
            title = ""
            price = ""
            author_name = ""
            num_pages = ""
            isbn = ""
            window_add_book.input("Title: ") {|msg| title = msg['text'] }
            window_add_book.input("Price: ") {|msg| price = msg['text'] }
            window_add_book.input("Author Name: ") {|msg| author_name = msg['text'] }
            window_add_book.input("Number Of Pages: ") {|msg| num_pages = msg['text'] }
            window_add_book.input("ISBN: ") {|msg| isbn = msg['text'] }
            window_add_book.button("Add".yellow){
                write_to_file(title + ',' + price + ',' + author_name + ',' + num_pages + ',' + isbn, "b")
                window_add_book.puts("Book Added Successfully".cyan) 
            }
            window_add_book.wait_until_closed
        }#End button "Add Book"
        
        window.button("Add Magazine".yellow){
            window_add_magazine =  Flammarion::Engraving.new
            window_add_magazine.puts("Add Magazine")
            # Magazine: Title, Price, Publisher Agent, Date
            title = ""
            price = ""
            publisher_agent = ""
            date = ""
            window_add_magazine.input("Title: ") {|msg| title = msg['text'] }
            window_add_magazine.input("Price: ") {|msg| price = msg['text'] }
            window_add_magazine.input("Publisher Agent: ") {|msg| publisher_agent = msg['text'] }
            window_add_magazine.input("Date: ") {|msg| date = msg['text'] }
            window_add_magazine.button("Add".yellow){
                write_to_file(title + ',' + price + ',' + publisher_agent + ',' + date, "m")
                window_add_magazine.puts("Magazine Added Successfully".cyan) 
            }
            window_add_magazine.wait_until_closed
        }#End button "Add Magazine"
        window.wait_until_closed
    }#End Add Store Item
    #--------------------------------------------------------------
    
    #list most expensive items
    f.button("List Most Expensive Items".green) {
        window = Flammarion::Engraving.new
        window.puts("Most 3 Expensive Items: ")
        window.puts()
        store_sorted_descendingly = sort_store_by_price(load_items)
        for i in 0..2
            store_sorted_descendingly[i].title =  store_sorted_descendingly[i].title.yellow
            store_sorted_descendingly[i].price = store_sorted_descendingly[i].price.green
            window.puts(store_sorted_descendingly[i])
        end
        }#End list most expensive items
    #----------------------------------------------------------------  

    #list books within certain range 
    f.button("List Books Within Certain Price Range".cyan) {
        window = Flammarion::Engraving.new
        window.puts "List Books Within Certain Price Range: ".cyan
        from = ""
        to = ""
        window.input("From"){|msg| from = msg['text']}
        window.input("To"){|msg| to = msg['text']}
        window.button("Search"){
            tmp_store = load_items
            tmp_book = Book.new()
            books_found = false
            tmp_store.each do |item|
                if item.class.name == tmp_book.class.name
                    if item.price.to_i >= from.to_i &&
                        item.price.to_i <= to.to_i
                        item.title = item.title.cyan
                        item.price = item.price.blue
                        window.puts(item.to_s)
                        books_found = true
                    end
                end
            end
            if !books_found
                window.puts "No books found".cyan
            end
        }#End Search button

    }#End list books within certain range 
    #----------------------------------------------

    #Search Magazine By Date
    f.button("Search Magazine By Date".light_blue) {
        window = Flammarion::Engraving.new
        date_from_user = ""
        window.puts("Search Magazine By Date")
        window.input("dd-mm-yyyy") {|msg| date_from_user = msg['text']}
        window.button ("Search".white){
            magazine = Magazine.new()
            arr = []
            magazine_found = false
            tmp_store = load_items 
            tmp_store.each do |item|
                if item.class.name == magazine.class.name
                    if item.date.to_s.delete("\n") == date_from_user
                        arr.push(item)
                    end
                end
            end
            if arr.length > 1
                arr.each do |item|
                    item.title = item.title.light_blue
                    item.date = item.date.light_blue
                    window.puts item
                end
            else 
                window.puts "No magazines found".light_blue
            end

        }#End window
        window.wait_until_closed
    }#End search magazine by date

    #------------------------------------------------------------------
    #searching by publisher name
    publisher_from_user = ""
    f.button("Search Magazine By Publisher".light_magenta) {
        window = Flammarion::Engraving.new 
        window.puts"Search Magazine By Publisher Agent".light_magenta
        window.input("Publisher Agent: ") {|msg| publisher_from_user = msg['text']}
        window.button("Search") {
            magazines = magazineByPublisher(load_items,publisher_from_user)
            if !magazines.empty?
                magazines.each do |item|
                    item.title = item.title.light_magenta
                    item.publisher_agent = item.publisher_agent.yellow
                    window.puts(item)
                end
            else
                window.puts"No magazines found".light_magenta
            end
            }
    }
    #---------------------------------------------------------------------
    #Delete item
    f.button("Delete Book / Magazine".light_red){
        window = Flammarion::Engraving.new
        window.puts "Delete Book / Magazine".light_red
        tmp_store = load_items
        titles = Array.new
        tmp_store.each do |item|
            titles.push(item.title)
        end
        item_from_user = titles[0] 
        window.dropdown(titles) {|h_msg| item_from_user = h_msg['text']}
        window.button("Delete Item") { 
              
            new_store = []  
            tmp_store.each do |item|
                if item.title != item_from_user
                    new_store.push(item)
                end
            end
            update_file(new_store)
            window.puts "Item deleted successfully".light_red
            }#End secondary Delete Item
    }#End primary Delete Book / Magazine
 #---------------------------------------------------------------------

    #List of all store items     
    f.button("List All Store Items".yellow) {
        window = Flammarion::Engraving.new 
        window.puts"All Items In Store: "
        window.puts()
        tmp_store = load_items
        tmp_book = Book.new()
        window.puts"---------------------------------------------------------------------------------------"
        window.puts()
        window.puts "All books in the store: ".yellow
        window.puts()
        tmp_store.each do |item|
            if item.class.name == tmp_book.class.name
                item.title = item.title.green
                window.puts item
            end
        end
        window.puts"---------------------------------------------------------------------------------------"

        tmp_magazine = Magazine.new()
        window.puts()
        window.puts "All magazines in the store: ".yellow
        window.puts()
        tmp_store.each do |item|
            if item.class.name == tmp_magazine.class.name
                item.title = item.title.cyan
                window.puts item
            end
        end
    }
    # f.dropdown([1,2,3]){|h_msg| p h_msg['text']}
    f.wait_until_closed
end
#-----------------------------------------End run_GUI---------------------------------------------------------------------

#main function
def main_func
    store = StoreItem.new
    store = load_items
    run_GUI (store)
end
#------------------------------------------End main_func------------------------------------------------------------------

main_func
