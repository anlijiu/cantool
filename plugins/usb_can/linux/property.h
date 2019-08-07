#ifndef PROPERTY_H
#define PROPERTY_H

#include <functional>
#include <map>

// A signal object may call multiple slots with the
// same signature. You can connect functions to the signal
// which will be called when the emit() method on the
// signal object is invoked. Any argument passed to emit()
// will be passed to the given functions.

template <typename... Args>
class Signal {

 public:

  Signal() : current_id_(0) {}

  // copy creates new signal
  Signal(Signal const& other) : current_id_(0) {}

  // connects a member function to this Signal
  template <typename T>
  int connect_member(T *inst, void (T::*func)(Args...)) {
    return connect([=](Args... args) { 
      (inst->*func)(args...); 
    });
  }

  // connects a const member function to this Signal
  template <typename T>
  int connect_member(T *inst, void (T::*func)(Args...) const) {
    return connect([=](Args... args) {
      (inst->*func)(args...); 
    });
  }

  // connects a std::function to the signal. The returned
  // value can be used to disconnect the function again
  int connect(std::function<void(Args...)> const& slot) const {
    slots_.insert(std::make_pair(++current_id_, slot));
    return current_id_;
  }

  // disconnects a previously connected function
  void disconnect(int id) const {
    slots_.erase(id);
  }

  // disconnects all previously connected functions
  void disconnect_all() const {
    slots_.clear();
  }

  // calls all connected functions
  void emit(Args... p) {
    for(auto it : slots_) {
      it.second(p...);
    }
  }

  // assignment creates new Signal
  Signal& operator=(Signal const& other) {
    disconnect_all();
  }

 private:
  mutable std::map<int, std::function<void(Args...)>> slots_;
  mutable int current_id_;
};



// A Property encapsulates a value and may inform
// you on any changes applied to this value.

template <typename T>
class Property {

 public:
  typedef T value_type;

  Property(T const& val) : value_(val) {}

  Property(T&& val)
      : value_(std::move(val)) {}

  Property(Property<T> const& to_copy)
      : value_(to_copy.value_) {}

  Property(Property<T>&& to_copy)
      : value_(std::move(to_copy.value_)) {}

  // returns a Signal which is fired when the internal value
  // has been changed. The new value is passed as parameter.
  virtual Signal<T> const& on_change() const {
    return on_change_;
  }

  // sets the Property to a new value.
  // on_change() will be emitted.
  virtual void set(T const& value) {
    if (value_ != value) {
      value_ = value;
      on_change_.emit(value_);
    }
  }

  // returns the internal value
  virtual T const& get() const { return value_; }

  // if there are any Properties connected to this Property,
  // they won't be notified of any further changes
  virtual void disconnect_auditors() {
    on_change_.disconnect_all();
  }

  // assigns the value of another Property
  virtual Property<T>& operator=(Property<T> const& rhs) {
    set(rhs.value_);
    return *this;
  }

  // assigns a new value to this Property
  virtual Property<T>& operator=(T const& rhs) {
    set(rhs);
    return *this;
  }

  // returns the value of this Property
  T const& operator()() const {
    return Property<T>::get();
  }

 private:
  Signal<T> on_change_;

  T value_;
};


// stream operators
template<typename T>
std::ostream& operator<<(std::ostream& str, Property<T> const& val) {
  str << val.get();
  return str;
}

template<typename T>
std::istream& operator>>(std::istream& str, Property<T>& val) {
  T tmp;
  str >> tmp;
  val.set(tmp);
  return str;
}

#endif /* PROPERTY_H */
