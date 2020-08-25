static int getTwoVar(lua_State *L)  
{  
    // 向函数栈中压入2个值  
    lua_pushnumber(L, 10);  
    lua_pushstring(L,"hello");  
   
    return 2;  
}  
 
int main(int argc, char const *argv[])
 {
 	
 	return 0;
 } 