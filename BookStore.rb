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



    File.open("Books.txt", "r") do |f|

        f.each_line do |line|

            if !line.empty? && line.to_s != ("\n")

                line_splitted = line.split(',')

                #Book.txt title,price,author name,number of pages,isbn 

                book_object = Book.new(line_splitted[0],line_splitted[1], line_splitted[2],line_splitted[3], line_splitted[4])

                store.push(book_object)

            end

        end



    end



    File.open("Magazines.txt", "r") do |f|

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

#2 arguments (store "array contains all books  and magazines") , (Publisher name : the name that I take from the user)

def magazineByPublisher(store,publisher_name)



    for i in store 



            #this condition displays that if publisher agent is in the books or in magazines 



        if(i.instance_variable_defined?(:@publisher_agent))



                if i.publisher_agent == publisher_name #condition returns the index contains the publisher agent



                



                return i



                end



        end



    end



        puts 'there is no magazine for this publisher'# if the publisher not found in the array it will print this msg



    return "There is no magazine for this agent";



end



#-----------------------------------------End Search function--------------------------------------------------------------



#append new book or magazine to the corresponding file



def write_to_file(item_info, book_or_magazine)



    if book_or_magazine == "b"

        File.write("/home/ubuntu/bookstore/BookStore/Books.txt", item_info + "\n", mode: 'a')

        

    else

        File.write("/home/ubuntu/bookstore/BookStore/Magazines.txt", item_info + "\n", mode: 'a')

    end

end



#----------------------------------------End write_to_file-----------------------------------------------------------------

#Delete from file

def update_file(store)

    temp_books = Book.new()

    temp_magazines = Magazine.new()

    books = []

    magazines=[]



    store.each do |item|

        if item.class.name == temp_books.class.name

            books.push(item)

        end 



        if item.class.name == temp_magazines.class.name

            magazines.push(item)

        end    

    end

        File.write("Books.txt", books)

        



        File.write("Magazines.txt", magazines)

    

end





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

#-------------------------------------------------------------------------------------------------------------------------

#Delete an Item function



#-----------------------------------------End sort_store_by_price---------------------------------------------------------







#run all the operations in GUI



def run_GUI(store)



    require 'flammarion'



    f = Flammarion::Engraving.new



    f.puts("Book Store")





    #Add Store Item

    f.button("Add Store Item"){

        

        window = Flammarion::Engraving.new

        

        window.button("Add Book"){

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



            window_add_book.button("Add Book"){

                write_to_file(title + ',' + price + ',' + author_name + ',' + num_pages + ',' + isbn, "b")

                window_add_book.puts("Book Added Successfully") 

            }



            window_add_book.wait_until_closed

        }#End button "Add Book"



        window.button("Add Magazine"){

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



            window_add_magazine.button("Add Magazine"){

                write_to_file(title + ',' + price + ',' + publisher_agent + ',' + date, "m")

                window_add_magazine.puts("Magazine Added Successfully") 

            }



            window_add_magazine.wait_until_closed



        }#End button "Add Magazine"



        window.wait_until_closed



    }#End Add Store Item





    #list most expensive items



    f.button("List Most Expensive Items".white) {

        window = Flammarion::Engraving.new

        window.puts("Most 3 Expensive Items: ")

        window.puts()

        store_sorted_descendingly = sort_store_by_price(load_items)

        for i in 0..2

            window.puts(store_sorted_descendingly[i])

        end

        }



    #list books within certain range 

    f.button("List Books Within Certain Price Range".white) {

        window = Flammarion::Engraving.new

        window.puts "List Books Within Certain Price Range: "

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

                        window.puts(item.to_s)

                        books_found = true



                    end



                end



            end



            if !books_found



                window.puts "No Books Found in That Range "



            end



        }#End Search button



        



    }#End list books within certain range 





    #Search Magazine By Date



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



                window.puts "No Magazine Found"



            end



        }#End window







        window.wait_until_closed



    }#End search magazine by date



    #------------------------------------------------------------------



    #searching by publisher name



    publisher_name = ""







    f.button("Search Magazine By Publisher") {



        publisher_agent = Flammarion::Engraving.new 



        publisher_agent.puts "Search magazine by publisher name"



        publisher_agent.input("Publisher Name") {|msg| publisher_name = msg['text']}



        publisher_agent.button("Search") {



            magazine = magazineByPublisher(store,publisher_name)



            publisher_agent.pane("magazinePublisherPane").puts(magazine.to_s)



            #p magazine   



        }



 }

 



 #---------------------------------------------------------------------

 #Delete item





f.button("Delete Book/Magazine"){

 

    window = Flammarion::Engraving.new

    

    window.puts "Delete Book/Magazine"

    temp_store = load_items

    

    titles = Array.new



    temp_store.each do |item|

        titles.push(item.title)

    end

    delete_item = titles[0] 



    window.dropdown(titles) {|h_msg| delete_item = h_msg['text']}

    temp_new = temp_store

    window.button("Delete Item") {     

        p temp_store

        i = 0

        while true

            

            if temp_store[i].title == delete_item

               deleted_book = temp_store.delete(temp_store[i])

                break

            end



            if  i < temp_store.length

                i+=1

            end



        end



        p temp_store

        window.puts "Item deleted successfully"

        update_file(temp_store)

        

        }

     

}



 #---------------------------------------------------------------------











    #List of all store items     

    f.button("List All Store Items".white) {

        window = Flammarion::Engraving.new 

        window.puts"All Items In Store: "

        window.puts()

        tmp_store = load_items

        tmp_store.each do |item|

            window.puts item

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
