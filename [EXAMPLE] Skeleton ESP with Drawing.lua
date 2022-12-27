local Brush = loadstring(game:HttpGet("https://raw.githubusercontent.com/1e20/ImGui/main/Modules/Drawing.lua"))();

local CAMERA = workspace.CurrentCamera; 
local PLAYERS = game:GetService("Players");
local LOCAL = PLAYERS.LocalPlayer;

local SkeletonTypes = {
    R15 = {
        SkeletonLegs = {
            "RightFoot";
            "RightLowerLeg";
            "RightUpperLeg"; 
            "LowerTorso";
            "LeftUpperLeg";
            "LeftLowerLeg";
            "LeftFoot";
        };
        
        SkeletonArms = {
            "LeftHand";
            "LeftLowerArm";
            "LeftUpperArm";
            "UpperTorso";
            "RightUpperArm";
            "RightLowerArm";
            "RightHand";
        };
        
        SkeletonSpine = {
            "Head";
            "UpperTorso";
            "LowerTorso";
        };
    };

    R6 = {
        SkeletonLegs = {
            "Left Leg"; 
            "Torso";
            "Right Leg";
        };
        
        SkeletonArms = {
            "Left Arm";
            "Torso"; 
            "Right Arm";
        };
        
        SkeletonSpine = {
            "Head";
            "Torso";
        };
    };
};

while true do 
    for _, player in next, PLAYERS:GetPlayers() do 
        if (not player.Character or LOCAL == player) then continue end; 

        local RenderTarget = player.Character; 
        local Rig = (RenderTarget:FindFirstChild("Torso") and "R6" or "R15");
        Rig = SkeletonTypes[Rig];

        for _, BoneCategory in next, Rig do 
            for index, Bone in next, BoneCategory do 
                local TrueIndex = index - (index ~= 1 and 1 or 0);
    
                if (not RenderTarget:FindFirstChild(BoneCategory[TrueIndex]) or not RenderTarget:FindFirstChild(Bone)) then continue end;
                local PreviousBonePosition, Visible = CAMERA:WorldToViewportPoint(RenderTarget[BoneCategory[TrueIndex]].Position);
                local CurrentBonePosition, Visible2 = CAMERA:WorldToViewportPoint(RenderTarget[Bone].Position);
                
                Brush:Draw(RenderTarget, 'Line', {
                    Visible = (Visible and Visible2);
                    From = Vector2.new(PreviousBonePosition.X, PreviousBonePosition.Y);
                    To = Vector2.new(CurrentBonePosition.X, CurrentBonePosition.Y);
                    Color = Color3.fromRGB(135, 206, 235);
                });
            end 
        end; 
    end; 

    Brush:EndDraw();
    task.wait();
end; 
