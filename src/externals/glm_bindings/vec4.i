// glm::vec4 bindings
%typemap(in) glm::vec4 (void *argp = 0, int res = 0) {
  int res = SWIG_ConvertPtr($input, &argp, $descriptor(glm::vec4*), $disown | 0);
  if (!SWIG_IsOK(res)) 
  { 
    if (!PySequence_Check($input)) {
      PyErr_SetString(PyExc_ValueError, "in method '" "$symname" "', argument " "$argnum" " Expected either a sequence or vec4");
      return NULL;
    }

    if (PySequence_Length($input) != 4) {
      PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Size mismatch. Expected 4 elements");
      return NULL;
    }

    for (int i = 0; i < 4; i++) {
      PyObject *o = PySequence_GetItem($input,i);
      if (PyNumber_Check(o)) {
        $1[i] = (float) PyFloat_AsDouble(o);
      } else {
        PyErr_SetString(PyExc_ValueError,"in method '" "$symname" "', argument " "$argnum" " Sequence elements must be numbers");      
        return NULL;
      }
    }
  }   
  else {
    glm::vec4 * temp = reinterpret_cast< glm::vec4 * >(argp);
    $1 = *temp;
    if (SWIG_IsNewObj(res)) delete temp;
  }
}

struct vec4 {
    
    float x, y, z, w;

    static length_t length();

    vec4();
    vec4(vec4 const & v);
    vec4(float scalar);
    vec4(float s1, float s2, float s3, float s4);
    vec4(vec2 const & a, vec2 const & b);
    vec4(vec2 const & a, float b, float c);
    vec4(float a, vec2 const & b, float c);
    vec4(float a, float b, vec2 const & c);
    vec4(vec3 const & a, float b);
    vec4(float a, vec3 const & b);

    /*vec4 & operator=(vec4 const & v);*/
};

vec4 operator+(vec4 const & v, float scalar);
vec4 operator+(float scalar, vec4 const & v);
vec4 operator+(vec4 const & v1, vec4 const & v2);
vec4 operator-(vec4 const & v, float scalar);
vec4 operator-(float scalar, vec4 const & v);
vec4 operator-(vec4 const & v1, vec4 const & v2);
vec4 operator*(vec4 const & v, float scalar);
vec4 operator*(float scalar, vec4 const & v);
vec4 operator*(vec4 const & v1, vec4 const & v2);
vec4 operator/(vec4 const & v, float scalar);
vec4 operator/(float scalar, vec4 const & v);
vec4 operator/(vec4 const & v1, vec4 const & v2);
/*vec4 operator%(vec4 const & v, float scalar);
vec4 operator%(float scalar, vec4 const & v);
vec4 operator%(vec4 const & v1, vec4 const & v2);*/
bool operator==(vec4 const & v1, vec4 const & v2);
bool operator!=(vec4 const & v1, vec4 const & v2);

%extend vec4 {

    // [] getter
    // out of bounds throws a string, which causes a Lua error
    float __getitem__(int i) throw (std::out_of_range) {
        #ifdef SWIGLUA
            if(i < 1 || i > $self->length()) {
                throw std::out_of_range("in glm::vec4::__getitem__()");
            }
            return (*$self)[i-1];
        #else
            if(i < 0 || i >= $self->length()) {
                throw std::out_of_range("in glm::vec4::__getitem__()");
            }
            return (*$self)[i];
        #endif
    }

    // [] setter
    // out of bounds throws a string, which causes a Lua error
    void __setitem__(int i, float f) throw (std::out_of_range) {
        #ifdef SWIGLUA
            if(i < 1 || i > $self->length()) {
                throw std::out_of_range("in glm::vec4::__setitem__()");
            }
            (*$self)[i-1] = f;
        #else
            if(i < 0 || i >= $self->length()) {
                throw std::out_of_range("in glm::vec4::__setitem__()");
            }
            (*$self)[i] = f;
        #endif
    }

    // tostring operator
    std::string __tostring() {
        std::stringstream str;
        for(glm::length_t i = 0; i < $self->length(); ++i) {
            str << (*$self)[i];
            if(i + 1 != $self->length()) {
                str << " ";
            }
        }
        return str.str();
    }

    // extend operators, otherwise some languages (lua)
    // won't be able to act on objects directly (ie. v1 + v2)
    vec4 operator+(vec4 const & v) {return (*$self) + v;}
    vec4 operator+(float scalar) {return (*$self) + scalar;}
    vec4 operator-(vec4 const & v) {return (*$self) - v;}
    vec4 operator-(float scalar) {return (*$self) - scalar;}
    vec4 operator*(vec4 const & v) {return (*$self) * v;}
    vec4 operator*(float scalar) {return (*$self) * scalar;}
    vec4 operator/(vec4 const & v) {return (*$self) / v;}
    vec4 operator/(float scalar) {return (*$self) / scalar;}
    /*vec4 operator%(vec4 const & v) {return (*$self) % v;}
    vec4 operator%(float scalar) {return (*$self) % scalar;}*/
    bool operator==(vec4 const & v) {return (*$self) == v;}
    bool operator!=(vec4 const & v) {return (*$self) != v;}
};
