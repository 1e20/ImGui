--[[
    How to use: 

    local Brush = Brush.New{};

    Brush:Draw(Object, 'Line', LineProperties);
    Brush:EndDraw(); -- De Queues Drawings (must do after drawing)
]]

local CORE = game:GetService("CoreGui");
local CAMERA = workspace.CurrentCamera; 
local DRAW = Drawing.new;

local Brush = { };
Brush.Memory = { Pool = { } };

function Brush.New()
    local NewBrush = {};

    for c, k in next, Brush do 
        NewBrush[c] = k; 
    end; 

    return NewBrush;
end;

function Brush.Memory:ValidateBuffer(Buffer)
    if (not Buffer.Object or not Buffer.Object.Parent or not Buffer.Object:IsDescendantOf(workspace)) then 
        return false;
    end;

    return true; 
end; 

function Brush.Memory:CreateBuffer(Object)
    if (not Object) then return false end;

    local Buffer = {
        Id = #self.Pool + 1;
        Object = Object;
        Queue = { 
            Line = { }; 
            Square = { };
            Circle = { };
            Quad = { };
            Text = { };
            Triangle = { };
        };
        Drawings = { 
            Line = { }; 
            Square = { };
            Circle = { };
            Quad = { };
            Text = { };
            Triangle = { };
        };
    };

    self.Pool[Object] = Buffer; 
    return Buffer;
end; 

function Brush.Memory:DeQueueBuffer(Buffer)
    for i, c in next, Buffer.Queue do 
        for y, b in next, c do 
            table.remove(c, y); 
            table.insert(Buffer.Drawings[i], b);
        end; 
    end; 
end; 

function Brush.Memory:Allocate(Object, Class, Properties)
    if (not Object) then return false end;

    local Buffer = ( self.Pool[Object] or self:CreateBuffer(Object) );
    local Drawing = ( Buffer.Drawings[Class][1] or DRAW(Class) );

    if (Drawing) then
        table.remove(Buffer.Drawings[Class], 1);
    end;

    table.insert(Buffer.Queue[Class], Drawing);

    for p, v in next, Properties do 
        Drawing[p] = v;
    end;

    return Drawing;
end;

function Brush:EndDraw()
    for i, m in next, self.Memory.Pool do 
        self.Memory:DeQueueBuffer(m);

        if (not self.Memory:ValidateBuffer(m)) then 
            for _, c in next, m.Drawings do 
                for _, drawing in next, c do drawing:Remove() end; 
            end; 
    
            for _, c in next, m.Queue do 
                for _, drawing in next, c do drawing:Remove() end; 
            end; 
    
            self.Memory.Pool[m.Object] = nil; 
        end;
    end; 
end; 

function Brush:Draw(Object, Class, Properties)
    assert((Class and Properties), "[Brush-Draw] Missing arguments");
    return self.Memory:Allocate(Object, Class, Properties);
end; 

return Brush;
