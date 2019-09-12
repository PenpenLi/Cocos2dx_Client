module("shader_factory", package.seeall)

local ccPositionTextureColor_noMVP_vert = 
[[
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

void main()
{
    gl_Position = CC_PMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
}
]]

function create_normal()
    local glProgam = cc.GLProgramCache:getInstance():getGLProgram("shader_normal")
    if not glProgam then
        glProgam = cc.GLProgram:createWithByteArrays(ccPositionTextureColor_noMVP_vert, shader_normal)
        cc.GLProgramCache:getInstance():addGLProgram(glProgam, "shader_normal")
    end
    return glProgam
end

function create_greyscale()
    local glProgam = cc.GLProgramCache:getInstance():getGLProgram("shader_greyscale")
    if not glProgam then
        glProgam = cc.GLProgram:createWithByteArrays(ccPositionTextureColor_noMVP_vert, shader_greyscale)
        cc.GLProgramCache:getInstance():addGLProgram(glProgam, "shader_greyscale")
    end
    return glProgam
end

function create_outline(color, threshold, radius)
    local glProgam = cc.GLProgramCache:getInstance():getGLProgram("shader_outline")
    if not glProgam then
        glProgam = cc.GLProgram:createWithByteArrays(ccPositionTextureColor_noMVP_vert, shader_outline)
        cc.GLProgramCache:getInstance():addGLProgram(glProgam, "shader_outline")
    end
    
    color = color or cc.vec3(1.0, 0.2, 0.3);
    threshold = threshold or 1.75;
    radius = radius or 0.01;
    local glprogramstate = cc.GLProgramState:getOrCreateWithGLProgram(glProgam)
    glprogramstate:setUniformVec3("u_outlineColor", color);
    glprogramstate:setUniformFloat("u_radius", radius);
    glprogramstate:setUniformFloat("u_threshold", threshold);

    return glProgam
end























