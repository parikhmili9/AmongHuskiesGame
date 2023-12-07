module server.source.deque;
// Run your program with:
// dmd Deque.d -unittest -of=test && ./test
//
// This will execute each of the unit tests telling you if they passed.

import std.stdio;
import std.conv;




/++ 
 * A Deque is a double-ended queue in which we can push and
    pop elements.
    
    Note: Remember we implement Deque as a class 
          because it is implementing an interface.
 +/

/*********************************
   ## Methods in the Deque: 
   void push_front(T x); -  Element is on the front of collection
 */

/++
   void push_back(T x); - Element is on the back of the collection
 +/
/++
   T pop_front(); - Element is removed from front and returned
    assert size > 0 before operation

    T pop_back(); - Element is removed from back and returned
    assert size > 0 before operation

    ref T at(size_t pos);- Retrieve reference to element at position at index
    assert pos is between [0 .. $] and size > 0

    ref T back(); - Retrieve reference to element at back of position
    assert size > 0 before operation

    ref T front(); - Retrieve element at front of position
    assert size > 0 before operation
 +/

interface Container(T){
    // Element is on the front of collection
    void push_front(T x);
    // Element is on the back of the collection
    void push_back(T x);
    // Element is removed from front and returned
    // assert size > 0 before operation
    T pop_front();
    // Element is removed from back and returned
    // assert size > 0 before operation
    T pop_back();
    // Retrieve reference to element at position at index
    // assert pos is between [0 .. $] and size > 0
    ref T at(size_t pos);
    // Retrieve reference to element at back of position
    // assert size > 0 before operation
    ref T back();
    // Retrieve element at front of position
    // assert size > 0 before operation
    ref T front();
    // Retrieve number of elements currently in container
    size_t size();
}

/*
    A Deque is a double-ended queue in which we can push and
    pop elements.
    
    Note: Remember we implement Deque as a class 
          because it is implementing an interface.
*/
/++ 
 ## Implementation Dets:

 The Deque is built on the basis of a collection - Dynamic Array. 
 It has two variables tracking the start and the end of the deque itself.  
 +/

/++ 
  ## It also has: 
  ### General Constructor 
  This is where one can create a new deque using the "new" keyword.
 +/

 /++ 
 ### Copy Constructor
 This is where one can create a new deque using another existing deque by copying the values of the existing deque to the new deque.
+/

/++
### opAssign  
This is so that the deque can use '=' to assign its values to a new deque. 
+/

/++ 
### opEquals 
This is a custom equals mthod that allows the deque to use '==' to compare the values istead of just the instances. 
+/

/++ 
### size
This is a method that allows user to see the size of the existing deque. 
+/
class Deque(T) : Container!(T){
    // Implement here
    private T[] deque;
    private auto stInd = 0;
    private size_t enInd = 0;
    this(){
        deque = new T[0];
    }

    // Copy constructor
    this(Deque!(T) rhs) {
        // writeln("Copy being made");
        deque = rhs.deque.dup;
        stInd = rhs.stInd;
        enInd = rhs.enInd;
    }

    // opAssign = 
    void opAssign(T[] other) {
        // Copy the elements from the other deque to this deque
        this.deque = other.dup;
        // writeln("Assign");
    }

    // opEquals
    bool opEquals(Deque!(T) other) const {
        // Compare the elements of the two deques
        // writeln("Equals");
        return (this.deque == other.deque);
    }

    private T[] temp;
    void push_front(T x){
        deque = [x] ~ deque;
        stInd = 0;

    }
    void push_back(T x){
        deque ~= x;
        enInd = deque.length - 1;
    }
    T pop_front() {
        assert(deque.length > 0);
        T val = deque[stInd];
        deque = deque[stInd + 1 .. $];
        stInd = 0;
        
        return val;
    }
    T pop_back(){
        size_t size = deque.length;
        assert(size > 0);
        T val = deque[enInd];
        deque = deque[0 .. size- 1];
        enInd = enInd - 1;
        return val;
    }
    ref T at(size_t pos){
        assert(size() > 0);
        assert(pos < size());

        return deque[pos];
    }
    ref T back(){
        assert((size() > 0));
        return deque[enInd];
    }
    ref T front(){
        assert(size() > 0);
        return deque[stInd];
    }
    size_t size(){
        return this.deque.length;
    }
    override string toString()
    {
        return to!(string)(deque);
    }

}

// An example unit test that you may consider.
// Try writing more unit tests in separate blocks
// and use different data types.

/++ 
Following are the Unit tests for the Deque. These are so that we can test the proper functioning of the deque Data Structure.
+/


unittest{
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    auto element = myDeque.pop_front();
    assert(element == 1);
}

/++ 
These are so that we can test the proper functioning of the deque Data Structure.
+/

unittest {
        auto deque = new Deque!(int);
        deque.push_front(1);
        deque.push_front(2);
        deque.push_front(3);
        assert(deque.front == 3);
        // writeln(deque.toString);
        assert(deque.size() == 3);
    }

    // Test push_back, back, and size methods with strings
/++ 
Test push_back, back, and size methods with strings
+/

unittest {
    auto deque = new Deque!(string);
    deque.push_back("a");
    deque.push_back("b");
    deque.push_back("c");
    assert(deque.back == "c");
    assert(deque.size == 3);
}

// Test pop_front and size methods with integers
/++ 
Test pop_front and size methods with integers
+/
unittest {
    auto deque = new Deque!(int);
    deque.push_back(1);
    deque.push_back(2);
    deque.push_back(3);
    assert(deque.pop_front == 1);
    assert(deque.size == 2);
}

// Test pop_back and size methods with strings
/++ 
Test pop_back and size methods with strings
+/
unittest {
    auto deque = new Deque!(string);
    deque.push_back("a");
    deque.push_back("b");
    deque.push_back("c");
    assert(deque.pop_back == "c");
    assert(deque.size == 2);
}

// Test at method with integers
/++ 
Test at method with integers
+/
unittest {
    auto deque = new Deque!(int);
    deque.push_back(1);
    deque.push_back(2);
    deque.push_back(3);
    assert(deque.at(1) == 2);
}

// Test at method with strings
unittest {
    auto deque = new Deque!(string);
    deque.push_back("apple");
    deque.push_back("banana");
    deque.push_back("cherry");
    // writeln(deque.back());
    assert(deque.at(2) == "cherry");
}

// Copy Constructor Unit test
/++ 
Copy Constructor Unit test
+/
unittest {
    auto deque = new Deque!(int);
        deque.push_front(1);
        deque.push_front(2);
        deque.push_front(3);
    auto dq2 = new Deque!(int)(deque);

    assert(dq2.front == deque.front);
    
}

// OpAssign Unit test
/++ 
OpAssign Unit test
+/
unittest {
    auto deque = new Deque!(string);

    deque.push_back("apple");
    deque.push_back("banana");
    deque.push_back("cherry");

    auto copiedDeque = new Deque!(string);
    copiedDeque = deque.deque;

    assert(copiedDeque.toString == deque.toString);
}

// opEquals Unit test
/++ 
opEquals Unit test
+/
unittest
{
    auto deque = new Deque!(string);

    deque.push_back("apple");
    deque.push_back("banana");
    deque.push_back("cherry");

    auto copiedDeque = new Deque!(string);
    auto dq2 = new Deque!(string)(deque);
    copiedDeque = deque.deque;

    bool myAns = copiedDeque == dq2;
    bool[] actual = new bool[3];
    int i = 0;
    foreach (string key; copiedDeque.deque)
    {
        actual[i] = key == dq2.deque[i];
        i++;
    }
    bool act;
    for(int j = 1; j < actual.length; j++){
        if (actual[j] != actual[j-1]){
            assert(false);
        }
        act = actual[j];
    }

    assert(act == myAns);
}

// Testing iterator using foreach loop
/++ 
Testing iterator using foreach loop
+/
unittest
{
    auto deque = new Deque!(int);
    deque.push_back(1);
    deque.push_back(2);
    deque.push_back(3);
    deque.push_back(4);

    ulong corInd = 1;
    ulong myInd;
    foreach (ind,int key; deque.deque)
    {
        if (key == 2){
            myInd = ind;
        }
    }

    
    assert(myInd == corInd);
}

// void main(){
//     // No need for a 'main', use the unit test feature.
//     // Note: The D Compiler can generate a 'main' for us automatically
//     //       if we are just unit testing, and we'll look at that feature
//     //       later on in the course.
// }

/**************** End of the Docs *****************/