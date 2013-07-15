

class wrapped_matte(

    string wrapped_handle = "";

) {
    
    uniform shader _wrapped;

    public void begin() {
        _wrapped = getshader(wrapped_handle);
    }

    public void surface(output color Ci, Oi) {
        if (_wrapped != null) {
            _wrapped->surface(Ci, Oi);
        }
    }

}
