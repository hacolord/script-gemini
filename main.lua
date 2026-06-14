local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- 1. Tạo Hub ScreenGui
local hubGui = Instance.new("ScreenGui")
hubGui.Name = "SupremeHub_FinalVersion"
hubGui.ResetOnSpawn = false
hubGui.Parent = playerGui

-- 2. Main Frame (Bảng điều khiển chính)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainHub"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 260, 0, 380) -- [CẬP NHẬT]: Tăng từ 320 lên 380 để chứa thêm nút thứ 4
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = hubGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

-- Tiêu đề Hub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "SUPREME HUB"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = mainFrame

-- Nút Đóng (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(1, 0) cCorner.Parent = closeBtn

-- 3. Hàm xử lý nạp Script nâng cao (Tự Check lỗi hệ thống)
local function loadScript(btn, url, scriptName)
    btn.Text = "LOADING..."
    
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success and content then
        local func, err = loadstring(content)
        if func then
            local runSuccess, runErr = pcall(func)
            if runSuccess then
                btn.Text = "✅ SUCCESS!"
            else
                btn.Text = "❌ RUN ERROR"
                warn("Lỗi thực thi [" .. scriptName .. "]: " .. tostring(runErr))
            end
        else
            btn.Text = "❌ CODE ERROR"
            warn("Lỗi cú pháp trong file GitHub [" .. scriptName .. "]: " .. tostring(err))
        end
    else
        btn.Text = "❌ HTTP ERROR"
        warn("Không thể tải file từ GitHub [" .. scriptName .. "]. Vui lòng kiểm tra lại mạng!")
    end
    
    task.wait(1)
    btn.Text = "LAUNCH " .. scriptName
end

-- Hàm khởi tạo nút bấm
local function createLoadButton(text, pos, color, loadUrl)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = "LAUNCH " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.Parent = mainFrame
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 10)
    bCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        loadScript(btn, loadUrl, text)
    end)
end

-- =================================================== --
--               DANH SÁCH CÁC LINK GITHUB             --
-- =================================================== --

-- Nút 1: Auto Teleport
createLoadButton(
    "AUTO TP", 
    UDim2.new(0, 20, 0, 70), 
    Color3.fromRGB(0, 102, 204),
    "https://raw.githubusercontent.com/hacolord/auto-tp/refs/heads/main/main.lua"
)

-- Nút 2: ESP Item
createLoadButton(
    "ESP ITEM", 
    UDim2.new(0, 20, 0, 140), 
    Color3.fromRGB(120, 40, 160),
    "https://raw.githubusercontent.com/hacolord/esp-item/refs/heads/main/main.lua"
)

-- Nút 3: Float System
createLoadButton(
    "FLOAT SYSTEM", 
    UDim2.new(0, 20, 0, 210), 
    Color3.fromRGB(40, 160, 100),
    "https://raw.githubusercontent.com/hacolord/float/refs/heads/main/main.lua"
)

-- [MỚI CHÈN] Nút 4: Target Tracker (Nạp trực tiếp từ link GitHub mới của bạn)
createLoadButton(
    "TARGET TRACKER", 
    UDim2.new(0, 20, 0, 280), -- Đặt thẳng hàng ngay dưới nút số 3
    Color3.fromRGB(180, 50, 50), -- Màu đỏ đậm chiến đấu cực ngầu
    "https://raw.githubusercontent.com/hacolord/-/refs/heads/main/main.lua"
)

-- =================================================== --

-- 4. Hệ thống Kéo thả bảng & Phím tắt 
local function setupDrag(f)
    local d, di, ds, sp
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            d = true ds = i.Position sp = f.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - ds
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end
    end)
end
setupDrag(mainFrame)

closeBtn.MouseButton1Click:Connect(function() 
    hubGui.Enabled = false 
end)

-- Nhấn phím Right Control (Ctrl bên phải) để Ẩn/Hiện lại Hub nhanh
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl then
        hubGui.Enabled = not hubGui.Enabled
    end
end)

print("Supreme Hub Loaded Successfully! Toggle key: Right Control")
