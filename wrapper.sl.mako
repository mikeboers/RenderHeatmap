<%doc>

Pipeline methods to wrap:

    public void displacement(output point P; output normal N);
    public void opacity(output color Oi);
    public void surface(output color Ci, Oi);
    public void volume(output color Ci, Oi);
    public void light(output vector L; output color Cl);
    public void prelighting(output color Ci, Oi);
    public void lighting(output color Ci, Oi);
    public void postlighting(output color Ci, Oi);

</%doc>
<%!

    pipeline_methods = (
        ('opacity', 'output color Oi', 'Oi'),
        ('surface', 'output color Ci, Oi', 'Ci, Oi'),
        ('volume', 'output color Ci, Oi', 'Ci, Oi'),
        ('prelighting', 'output color Ci, Oi', 'Ci, Oi'),
        ('lighting', 'output color Ci, Oi', 'Ci, Oi'),
        ('diffuselighting', 'output color Ci, Oi', 'Ci, Oi'),
        ('specularlighting', 'output color Ci, Oi', 'Ci, Oi'),
        ('postlighting', 'output color Ci, Oi', 'Ci, Oi'),
    )

%>

plugin "time_shadeops";

class ${name}(

    string wrapped_handle = "";

    % for method, _, _ in pipeline_methods:
    output uniform float ${method}Time;
    % endfor

) {
    
    uniform shader _wrapped;

    public void construct() {
    }

    public void begin() {
        _wrapped = getshader(wrapped_handle);
    }

    % for method, params, args in pipeline_methods:
    % if method in methods:

    public void ${method}(${params}) {
        uniform float startTime = time();
        if (_wrapped != null) {
            _wrapped->${method}(${args});
        }
        ${method}Time = time() - startTime;
    }
    
    % endif
    % endfor

}
