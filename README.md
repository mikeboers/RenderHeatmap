Render Stat Heatmaps
====================

Proof of concept statistics collector for Pixar's RenderMan. It allows collection of statistic per shading group, **without** modifying existing shaders.

<img src="http://mikeboers.com/imgsizer/blog/2013-07-15-heatmaps/matte-HD.time.jpeg?h=300&m=crop&v=UeQ9JA&w=400&s=eRaAXX-YpZ8nzK4w16sJWe6iPis" />

TODO
----

- expose all AOVs of the wrapped shader
- expose all public attributes of the wrapped shader (for message passing in RSL)
- expose all shader pipeline methods of the wrapped shader
- expose all special shader parameters of the wrapped shader

- more examples
  - spheres
  - spheres with a delay
  - ambient occlusion
  - effect of shading rate
