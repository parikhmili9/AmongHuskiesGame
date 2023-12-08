module client.source.deque;

// Run your program with: 
// dmd Deque.d -unittest -of=test && ./test
//
// This will execute each of the unit tests telling you if they passed.

import std.stdio;
import std.random: uniform;
import std.algorithm.mutation;
import std.algorithm: canFind;
import std.exception: assertThrown;
import core.exception: AssertError;

/** 
    An interface for a Container abstract data type    
 */
interface Container(T){
    /** Push element to the front of collection */
    void push_front(T x);
    /** Push the element to the back of collection */
    void push_back(T x);
    /** Pop an element removed from front and returned */
    T pop_front();
    /** Element is removed from back and returned */
    T pop_back();
    /** Retrieve reference to element at position at index */
    ref T at(size_t pos);
    /** Retrieve reference to element at back of position */
    ref T back();
    /** Retrieve element at front of position */
    ref T front();
    /** Retrieve number of elements currently in container */
    size_t size();
    /** Tells whether the container is empty */
    bool empty();
}

/**
    A Deque is a double-ended queue in which we can push and
    pop elements.

    Implements the Container interface.

*/
class Deque(T) : Container!(T){
    
    T[] deque;
    
    this() {
        deque = [];
    }

    // Copy Constructor    
    this(const Deque dequeCopy) {
        // make a deep copy of this deque's array and assign it to the
        // incoming deque
        this.deque = dequeCopy.deque.dup();
    }

    /***********************************
    * Non-identity assignment operator overload.
    * Params:
    *      dequeData = the T[] that will represent the deque's 
    *                  data after an assignment operation.
    */
    void opAssign(const T[] dequeData) {
        // copy the data to ensure that we are only copying values
        this.deque = dequeData.dup();
    }

    
    /***********************************
    * Equivalence operator overload.
    * Params:
    *      other = the Deque object to which this Deque object
    *              will be compared.
    */
    bool opEquals(const Deque other) const {
        
        // if lengths aren't matching they can't be equal
        if (other.deque.length != this.deque.length) { return false; }
        
        // address is the same then they are equal
        auto addrA = &this;
        auto addrB = &other;
        if (addrA == addrB) { return true; }

        // element equality check
        for (int i = 0; i < other.deque.length; i++) {
            if (this.deque[i] != other.deque[i]) { return false; }
        }
        return true;
    }

    /***********************************
    * Pushes element `x` to the front of this Deque object.
    * Params:
    *      x = the element to be pushed to the front of the Deque.
    */
    void push_front(T x) {
        // deque reallocated with new element at the front
        T[] front = [x];
        deque = front ~= deque;
    }
    
    /***********************************
    * Pushes element `x` to the back of this Deque object.
    * Params:
    *      x = The element to be pushed to the back of the Deque.
    */
    void push_back(T x) {
        // deque reallocated with new element at the back
        deque ~= x;
    }

    /***********************************
    * Pops and returns the element that is at the front of this Deque object.
    * Returns: `T` type element from the front of the Deque
    */
    T pop_front() {

        // ensure something can be removed
        assert(deque.length > 0);
        T val = deque[0];
        deque = deque[1..deque.length];
        return val;
    }
    
    /***********************************
    * Pops and returns the element that is at the back of this Deque object.
    * Returns: `T` type element from the back of the Deque
    */
    T pop_back() {
        assert(deque.length > 0);
        auto idx = (deque.length)-1;
        
        T val = deque[idx];
        deque = deque[0..idx];
        return val;
    }
    
    /***********************************
    * Retrieves (but does not remove) the element at the requested index from this Deque object.
    * Returns: `T` reference of the element at the specified index within the Deque.
    */
    ref T at(size_t pos) {
        assert(pos >= 0 && pos < deque.length && deque.length > 0);
        return deque[pos];
    }

    /***********************************
    * Retrieves (but does not remove) the element from the back of the Deque object.
    * Returns: `T` reference of the element at the back of the Deque.
    */
    ref T back() {
        assert(deque.length > 0);
        auto idx = (deque.length)-1;
        return deque[idx];
    }

    /***********************************
    * Retrieves (but does not remove) the element from the front of the Deque object.
    * Returns: `T` reference of the element at the front of the Deque.
    */
    ref T front() {
        assert(deque.length > 0);
        return deque[0];
    }

    /***********************************
    * Gets the size of the Deque in terms of the number of elements it holds.
    */
    size_t size() {
        return deque.length;
    }

    /***********************************
    * Tells whether the Deque is empty.
    */
    bool empty() {
        return deque.length <= 0;
    }

    /***********************************
    * popFront implementation for iterator implementation
    */
    void popFront() {
        // ensure something can be removed
        assert(deque.length > 0);
        deque = deque[1..deque.length];
    }
}

const int N = 5;
const int UPPER_RANGE = 5;

// An example unit test that you may consider.
// Try writing more unit tests in separate blocks
// and use different data types.
unittest{
    // initial unit test
    auto myDeque = new Deque!(int);
    myDeque.push_front(1);
    auto element = myDeque.pop_front();
    assert(element == 1);
}

/* Test removal from the back of an empty deque */
///
unittest
{
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.pop_back());
}

/* Test removal from the front of an empty deque */
unittest
{
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.pop_front());
}

/* Test retrieval from empty deque */
unittest
{
    auto myDeque = new Deque!(int);
    assertThrown!AssertError(myDeque.pop_front());
}

/* test size is working as expected (Deque of Deques) */
unittest
{
    auto myDeque = new Deque!(string);
    assert(myDeque.size() == 0);
    // push random values to the front of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = "new Deque!(int)";
        myDeque.push_front(val);
    }
    assert(myDeque.size() == N);
}

/* Test retrieval from out-of-bounds index */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the front of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_front(val);
    }
    assertThrown!AssertError(myDeque.at(N + 10));
}
/* Test retrieval from valid index */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the front of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_back(val);
    }
    auto validIdx = uniform(0, N);
    assert(myDeque.at(validIdx) == randomVals[validIdx]);
}

/* add from the front and assert value equality from the back */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the front of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_front(val);
    }
    
    // iterate the array and assert that values popped from the deque are the same as the ones entered
    for (int j = 0; j < N; j++) {
        auto insertedVal = randomVals[j];
        assert(myDeque.back() == insertedVal);
        auto pop = myDeque.pop_back();
        assert(pop == insertedVal);
    }
}

/* add from the back and assert value equality from the back */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the back of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_back(val);
    }
    
    // reverse iterate the array and assert that values popped from the deque are the same as the ones entered
    for (int j = N-1; j > 0; j--) {
        auto insertedVal = randomVals[j];
        assert(myDeque.back() == insertedVal);
        auto pop = myDeque.pop_back();
        assert(pop == insertedVal);
    }
}

/* add from the front and assert value equality from the front */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the back of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_front(val);
    }
        // reverse iterate the array and assert that values popped from the deque are the same as the ones entered
    for (int j = N-1; j > 0; j--) {
        auto insertedVal = randomVals[j];
        assert(myDeque.front() == insertedVal);
        auto pop = myDeque.pop_front();
        assert(pop == insertedVal);
    }
}

/* add from the back and assert value equality from the front */
unittest
{
    int[] randomVals; 
    auto myDeque = new Deque!(int);
    // push random values to the back of the deque and store them in an array
    for (int i = 0; i < N; i++) {
        auto val = uniform(0, UPPER_RANGE);
        randomVals ~= val;
        myDeque.push_back(val);
    }
    
    // reverse iterate the array and assert that values popped from the deque are the same as the ones entered
    for (int j = 0; j < N; j++) {
        auto insertedVal = randomVals[j];
        assert(myDeque.front() == insertedVal);
        auto pop = myDeque.pop_front();
        assert(pop == insertedVal);
    }
}

/* Test the copy constructor */
unittest {
    
    Deque!(string) original = new Deque!(string);
    
    original.push_front("hey");            
    original.push_front("we're");
    original.push_front("testing");

    // Create a copy
    Deque!(string) duplicate = new Deque!(string)(original);

    // assert that the values of the original and the copy are the same
    assert(original.front() == duplicate.front());

    // assert that values contained within the deque are not referring to the same address
    string x = original.front();
    string y = original.front();
    assert(&x != &y);
    
    // mutate the duplicate and assert that the front values are no longer equal
    duplicate.pop_front();
    assert(original.front() != duplicate.front());
}

/** Test opAssign */
/** Authors: me */
unittest {
    Deque!(string) myDeque = new Deque!(string);
    string[] myArray1 = ["we're", "testing", "now"];

    // populate the deque
    myDeque.push_front("a");
    myDeque.push_front("b");
    myDeque.push_front("c");
    
    // opAssign the array to the dequeu
    myDeque = myArray1;
    string[] testArray = [];
    
    // fill the test array with the values from the deque
    testArray ~= myDeque.pop_front();
    testArray ~= myDeque.pop_front();
    testArray ~= myDeque.pop_front();

    // assert that the values taken from the deque are the values given to it
    // from the opAssign
    for (int i = 0; i < myArray1.length; i++) {
        assert(testArray[i] == myArray1[i]);
    }
}

/* Test opEquals */
unittest {
    Deque!(string) dequeA = new Deque!(string);
    Deque!(string) dequeB = new Deque!(string);
    Deque!(string) dequeC = dequeA;
    string[] myArray1 = ["we're", "testing", "now"];

    // assert equal addresses
    assert(dequeA == dequeC);
    
    // populate the deque
    foreach (string el; myArray1) {
        dequeA.push_front(el);
        dequeB.push_front(el);
    }

    // assert equal elements
    assert(dequeA == dequeB);

    // assert equal length; unequal elements
    dequeA.pop_front();
    dequeA.push_front("new string");
    assert(!(dequeA == dequeB));

    // assert unequal length; unequal elements
    dequeA.pop_front();
    assert(!(dequeA == dequeB));
}

// test iterator
unittest {
    
    auto myIterator = new Deque!(int);

    int[] ints = [];
    // populate the deque and an aux-array that will 
    // be used for verifying foreach loop
    foreach (i; 0..20) {
        auto x = uniform(1, 100);
        myIterator.push_front(x);
        ints ~= x;
    }

    // assert that everything put into the deque
    // is seen on the foreach
    foreach (int el; myIterator) {
        assert(canFind(ints, el));
    }
}