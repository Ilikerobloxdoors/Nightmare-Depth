
local Creator = loadstring(game:HttpGet(
    "https://pastebin.com/raw/0fSnvfGt"
))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- NIGHTMARE DEPTH VISUAL EFFECTS

local color = Instance.new("ColorCorrectionEffect")
color.Name = "NightmareDepthColor"
color.Enabled = false
color.Parent = Lighting

local blur = Instance.new("BlurEffect")
blur.Name = "NightmareDepthBlur"
blur.Size = 0
blur.Parent = Lighting

local sound = Instance.new("Sound")
sound.Name = "NightmareDepthSound"
sound.SoundId = "rbxassetid://138175227296034"
sound.Volume = 1
sound.Parent = SoundService

local effectActive = false
local shakeName = "NightmareDepthShake"

local function startEffect()
    if effectActive then return end
    effectActive = true

    color.Enabled = true

    TweenService:Create(color, TweenInfo.new(1.2), {
        TintColor = Color3.fromRGB(20, 35, 110),
        Brightness = -0.25,
        Contrast = 0.35,
        Saturation = -0.35,
    }):Play()

    TweenService:Create(blur, TweenInfo.new(1.2), {
        Size = 3,
    }):Play()

    sound:Play()

    local started = os.clock()
    local duration = 4
    local lastOffset = CFrame.new()

    RunService:UnbindFromRenderStep(shakeName)

    RunService:BindToRenderStep(
        shakeName,
        Enum.RenderPriority.Camera.Value + 1,
        function()
            local camera = workspace.CurrentCamera
            if not camera then return end

            camera.CFrame = camera.CFrame * lastOffset:Inverse()

            local elapsed = os.clock() - started
            if elapsed >= duration then
                lastOffset = CFrame.new()
                RunService:UnbindFromRenderStep(shakeName)
                return
            end

            local strength = 0.22 * (1 - elapsed / duration)

            lastOffset = CFrame.new(
                (math.random() - 0.5) * 2 * strength,
                (math.random() - 0.5) * 2 * strength,
                0
            )

            camera.CFrame = camera.CFrame * lastOffset
        end
    )
end

local function stopEffect()
    effectActive = false
    RunService:UnbindFromRenderStep(shakeName)
    sound:Stop()

    TweenService:Create(color, TweenInfo.new(1.5), {
        TintColor = Color3.fromRGB(255, 255, 255),
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
    }):Play()

    TweenService:Create(blur, TweenInfo.new(1.5), {
        Size = 0,
    }):Play()

    task.delay(1.6, function()
        if not effectActive then
            color.Enabled = false
        end
    end)
end

-- NIGHTMARE DEPTH ENTITY

local entity = Creator.createEntity({
    CustomName = "Nightmare Depth",

    Model = "https://raw.githubusercontent.com/Ilikerobloxdoors/Nightmare-Depth/main/Nightmare%20Depth.rbxm",

    Speed = 300,
    DelayTime = 4,
    HeightOffset = 0,

    CanKill = true,
    KillRange = 40,
    BreakLights = true,
    BackwardsMovement = false,

    FlickerLights = {
        false,
        1,
    },

    Cycles = {
        Min = 2,
        Max = 6,
        WaitTime = 0.05,
    },

    CamShake = {
        true,
        {11, 30, 0.1, 1},
        100,
    },

    Jumpscare = {
        true,
        {
            Image1 = "rbxassetid://137268666362769",
            Image2 = "rbxassetid://137268666362769",
            Shake = true,

            Sound1 = {
                10483790459,
                {Volume = 0.5},
            },

            Sound2 = {
                87799694751890,
                {Volume = 0.5},
            },

            Flashing = {
                true,
                Color3.fromRGB(247, 5, 5),
            },

            Tease = {
                true,
                Min = 1,
                Max = 2,
            },
        },
    },

    CustomDialog = {
        "You died to Nightmare Depth...",
        "The darkness has consumed you.",
    },
})

-- ENTITY CALLBACKS

entity.Debug.OnEntitySpawned = function(entityTable)
    print("Nightmare Depth spawned:", entityTable.Model)
    startEffect()
end

entity.Debug.OnEntityDespawned = function(entityTable)
    print("Nightmare Depth despawned:", entityTable.Model)
    stopEffect()
end

entity.Debug.OnEntityStartMoving = function(entityTable)
    print("Nightmare Depth started moving:", entityTable.Model)
end

entity.Debug.OnEntityFinishedRebound = function(entityTable)
    print("Nightmare Depth finished rebound:", entityTable.Model)
end

entity.Debug.OnEntityEnteredRoom = function(entityTable, room)
    print("Nightmare Depth entered room:", room)
end

entity.Debug.OnLookAtEntity = function(entityTable)
    print("Player looked at Nightmare Depth:", entityTable.Model)
end

entity.Debug.OnDeath = function(entityTable)
    warn("Player died to Nightmare Depth.")
end

-- RUN

Creator.runEntity(entity)
