<% '''

public void displacement(output point P; output normal N);
public void opacity(output color Oi);
public void surface(output color Ci, Oi);
public void volume(output color Ci, Oi);
public void light(output vector L; output color Cl);
public void prelighting(output color Ci, Oi);
public void lighting(output color Ci, Oi);
public void postlighting(output color Ci, Oi);

''' %>

class ${name}(

    string wrapped_handle = "";

) {
    
    uniform shader _wrapped;

    public void begin() {
        _wrapped = getshader(wrapped_handle);
    }

    % if 'surface' in methods:
    public void surface(output color Ci, Oi) {
        if (_wrapped != null) {
            _wrapped->surface(Ci, Oi);
        }
    }
    % endif

}
