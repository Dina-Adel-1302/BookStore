
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
        return "Title: " + @title.to_s + " Price: " + @price.to_s + " Author: " + @author_name.to_s +
        " Number of pages: " + @num_pages.to_s + " ISBN: " + @isbn.to_s
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
        return "Title: " + @title.to_s + " Price: " + @price.to_s + " Publisher agent: " + @publisher_agent.to_s + 
                " Date: " + @date.to_s
    end

end

#read the data of books and magazines from files, then store the data in an array of StoreItem 
def load_items
    
    store = []

    File.open("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Books.txt", "r") do |f|
        f.each_line do |line|
            line_splitted = line.split(',')
            #Book.txt title,price,author name,number of pages,isbn 
            #line_splitted[4] = line_splitted[4].delete("\n")
            book_object = Book.new(line_splitted[0],line_splitted[1], line_splitted[2],line_splitted[3], line_splitted[4])
            store.push(book_object)
        end
    end
     
    File.open("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Magazines.txt", "r") do |f|
        f.each_line do |line|
            line_splitted = line.split(',')
            #Magazine.txt #title,price,publisher-agent,date
            #line_splitted[3] = line_splitted[3].delete("\n")
            magazine_object = Magazine.new(line_splitted[0],line_splitted[1], line_splitted[2],line_splitted[3])
            store.push(magazine_object)
        end
    end

    return store

end
#----------------------------------------End load_items-------------------------------------------------------------------

#append new book or magazine to the corresponding file
def write_to_file(item_info, book_or_magazine)
    
    if book_or_magazine == "b"
        File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Books.txt", item_info, mode: 'a')
    else
        File.write("/home/dina/Documents/cloud computing/Sprints - DevOps/Ruby/Tasks/BookStore/Magazines.txt", item_info, mode: 'a')
    end

end
#----------------------------------------End write_to_file-----------------------------------------------------------------

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
    f.puts("Book Store")
    
    #Add new item
    item_info = ""
    book_or_magazine = "Add Book"
    f.dropdown(["Add Book", "Add Magazine"]){|user_choose| book_or_magazine = user_choose['text']}
    txtBox_txt = "Title, Price, Author name, Number of pages, ISBN"
    if book_or_magazine == "Add Magazine"
        txtBox_txt = "Title, Price, Publisher agent, Date"
    end
    f.input(txtBox_txt) {|item_info_from_user| item_info = item_info_from_user['text'] }
    f.button("Add store item".white) {if book_or_magazine == "Add Book"  
                                            write_to_file(item_info, "b") 
                                        else  
                                            write_to_file(item_info, "m") 
                                        end}

    #list most expensive items
    store_sorted_descendingly = sort_store_by_price(load_items)
    most_3_expensive_items = []
    for i in 0..2
        most_3_expensive_items.push(store_sorted_descendingly[i])
    end
    f.button("List most expensive items".white) {f.puts most_3_expensive_items}

    #list books within certain range 
    f.button("List Books Within Certain Price Range".white) {
        window = Flammarion::Engraving.new
        books_found = false
        range_from_user = ""
        window.input("Price Range: 0-1000000"){|msg| range_from_user = msg['text']}
        window.button("Search"){
            tmp_store = load_items
            range_from_user = range_from_user.split("-")
            tmp_book = Book.new()
            tmp_store.each do |item|
                if item.class.name == tmp_book.calss.name
                    if item.price.to_i > range_from_user[0] &&
                        item.price < range_from_user[1]
                        window.puts item
                        books_found = true
                    end
                end
            end
            if !books_found
                window.puts "No Books Found in That Range "
            end
        }#End Search button


    }#End list books within certain range 

    
    #search magazine by date
    f.button("Search Magazine By Date".white) {
        window = Flammarion::Engraving.new
        date_from_user = ""
        window.input("dd-mm-yyyy") {|msg| date_from_user = msg['text']}
        window.button ("Search".white){
            magazine = Magazine.new()
            magazine_found = false
            tmp_store = load_items 
            tmp_store.each do |item|
                if item.class.name == magazine.class.name
                    if item.date.to_s.delete("\n") == date_from_user
                        magazine = item 
                        magazine_found = true
                        break 
                    end
                end
                if magazine_found
                    break
                end
            end
            if magazine_found 
                window.puts magazine
            else 
                window.puts "Magazine Not Found"
            end
        }#End window

        window.wait_until_closed
    }#End search magazine by date 

    #List of all store items     
    f.button("List of all store items".white) {f.puts load_items}

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


 