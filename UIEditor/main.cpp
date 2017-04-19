// ImGui - standalone example application for Glfw + OpenGL 2, using fixed pipeline
// If you are new to ImGui, see examples/README.txt and documentation at the top of imgui.cpp.

#include <imgui.h>
#include "imgui_impl_glfw.h"
#include <stdio.h>
#include <GLFW/glfw3.h>
#include <lua.hpp>
#include <imgui_lua_bindings.cpp>
#include <freeimage.h>

static void error_callback(int error, const char* description)
{
    fprintf(stderr, "Error %d: %s\n", error, description);
}

void print_lua_error(lua_State *L) {
    const char* msg = lua_tostring(L, -1);
    error_callback(1, msg);
    lua_pop(L, 1);
}

lua_State* init_lua()
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);

    int result = luaL_loadfile(L, "./scripts/main.lua");
    if (result != LUA_OK)
    {
        print_lua_error(L);
        return nullptr;
    }

    result = lua_pcall(L, 0, LUA_MULTRET, 0);
    if (result != LUA_OK)
    {
        print_lua_error(L);
        return nullptr;
    }
    return L;
}

int create_input_lua(lua_State* L)
{
    static const int MAX_LEN = 512;
    char str[MAX_LEN] = "";
    const char* label = luaL_checkstring(L, 1);
    const char* s = luaL_checkstring(L, 2);
    strncpy(str, s, MAX_LEN);
    str[MAX_LEN - 1] = '\0';
    lua_pushboolean(L, ImGui::InputText(label, str, MAX_LEN));
    lua_pushstring(L, str);
    return 2;
}

int create_texture_lua(lua_State* L)
{
    const char* filepath = luaL_checkstring(L, 1);
    FIBITMAP* bitmap = FreeImage_Load(FreeImage_GetFileType(filepath, 0), filepath);
    int width = FreeImage_GetWidth(bitmap);
    int height = FreeImage_GetHeight(bitmap);
    unsigned char *pixels = (unsigned char*)FreeImage_GetBits(bitmap);
    unsigned int id = Imgui_ImplGlfw_CreateGLTex(width, height, pixels);
    lua_pushinteger(L, id);
    lua_pushinteger(L, width);
    lua_pushinteger(L, height);
    return 3;
}

void lua_binding(lua_State* L)
{
    luaL_Reg guilib[] = {
        {"CreateInput", create_input_lua},
        {"CreateTexture", create_texture_lua},
        {NULL, NULL}
    };
    lua_getglobal(L, "imgui");
    luaL_setfuncs(L, guilib, 0);
}

int main(int, char**)
{
    // Setup window
    glfwSetErrorCallback(error_callback);
    if (!glfwInit())
        return 1;
    GLFWwindow* window = glfwCreateWindow(1280, 720, "UIEditor", NULL, NULL);
    glfwMakeContextCurrent(window);

    // Setup ImGui binding
    ImGui_ImplGlfw_Init(window, true);

    bool show_test_window = true;
    bool show_another_window = false;
    ImVec4 clear_color = ImColor(114, 144, 154);
    
    lua_State *L = init_lua();
    if (L == nullptr)
    {
        return 1;
    }
    lState = L;
    LoadImguiBindings();
    lua_binding(L);

    // Main loop
    while (!glfwWindowShouldClose(window))
    {
        glfwPollEvents();
        ImGui_ImplGlfw_NewFrame();

        lua_getglobal(L, "renderFromC");
        if (lua_pcall(L, 0, 0, 0))
            print_lua_error(L);
//        // 1. Show a simple window
//        // Tip: if we don't call ImGui::Begin()/ImGui::End() the widgets appears in a window automatically called "Debug"
//        {
//            static float f = 0.0f;
//            ImGui::Text("Hello, world!");
//            ImGui::SliderFloat("float", &f, 0.0f, 1.0f);
//            ImGui::ColorEdit3("clear color", (float*)&clear_color);
//            if (ImGui::Button("Test Window")) show_test_window ^= 1;
//            if (ImGui::Button("Another Window")) show_another_window ^= 1;
//            ImGui::Text("Application average %.3f ms/frame (%.1f FPS)", 1000.0f / ImGui::GetIO().Framerate, ImGui::GetIO().Framerate);
//        }
//
//        // 2. Show another simple window, this time using an explicit Begin/End pair
//        if (show_another_window)
//        {
//            ImGui::SetNextWindowSize(ImVec2(200,100), ImGuiSetCond_FirstUseEver);
//            ImGui::Begin("Another Window", &show_another_window);
//            ImGui::Text("Hello");
//            ImGui::End();
//        }
//
//        // 3. Show the ImGui test window. Most of the sample code is in ImGui::ShowTestWindow()
//        if (show_test_window)
//        {
//            ImGui::SetNextWindowPos(ImVec2(650, 20), ImGuiSetCond_FirstUseEver);
//            ImGui::ShowTestWindow(&show_test_window);
//        }

        // Rendering
        int display_w, display_h;
        glfwGetFramebufferSize(window, &display_w, &display_h);
        glViewport(0, 0, display_w, display_h);
        glClearColor(clear_color.x, clear_color.y, clear_color.z, clear_color.w);
        glClear(GL_COLOR_BUFFER_BIT);
        ImGui::Render();
        glfwSwapBuffers(window);
    }

    // Cleanup
    ImGui_ImplGlfw_Shutdown();
    glfwTerminate();

    return 0;
}
