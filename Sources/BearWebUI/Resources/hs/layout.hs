def Layout.toggleMenu()
    if window.innerWidth is less than 768
       toggleMenu()
    end
end

def Layout.toggleNav()
    if window.innerWidth is less than 768
        toggleNav()
        hideMenu()
    end
end

def toggleMenu()
    if #menu-checkbox.checked
        set #menu-checkbox.checked to false
    else
        set #menu-checkbox.checked to true
    end
end

def toggleNav()
    if #nav-checkbox.checked
        set #nav-checkbox.checked to false
    else
        set #nav-checkbox.checked to true
    end
end

def hideMenu()
    set #menu-checkbox.checked to false
end

def hideNav()
    set #nav-checkbox.checked to true
    then set #menu-checkbox.checked to false
end

def showNav()
    set #nav-checkbox.checked to false
    then set #menu-checkbox.checked to false
end

def showMenu()
   set #menu-checkbox.checked to true
   then set #nav-checkbox.checked to false
end

def toggleLayout()
    if #nav-checkbox.checked is false
        if #menu-checkbox.checked is false
            set #menu-checkbox.checked to true
        else
            set #menu-checkbox.checked to false
            then set #nav-checkbox.checked to true
        end
    else
        set #nav-checkbox.checked to false
    end
end
