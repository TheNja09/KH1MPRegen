UA = 0
_BadAnimations = {56, 59, 62, 65, 68, 71, 58, 61, 64, 67, 70, 73, 212, 221, 222, 223, 224, 225, 226, 227, 241, 242, 243, 244, 245, 246, 247, 248, 232, 233, 4}
function _OnFrame()
    World = ReadByte(Now + 0x00)
    Room = ReadByte(Now + 0x01)
    Place = ReadShort(Now + 0x00)
    Door = ReadShort(Now + 0x02)
    Map = ReadShort(Now + 0x04)
    Btl = ReadShort(Now + 0x06)
    Evt = ReadShort(Now + 0x08)
    Cheats()
end

function _OnInit()
    if GAME_ID == 0xF266B00B or GAME_ID == 0xFAF99301 and ENGINE_TYPE == "ENGINE" then--PCSX2
        Platform = 'PS2'
        Now = 0x032BAE0 --Current Location
        Save = 0x032BB30 --Save File
        Obj0 = 0x1C94100 --00objentry.bin
        Sys3 = 0x1CCB300 --03system.bin
        Btl0 = 0x1CE5D80 --00battle.bin
        Slot1 = 0x1C6C750 --Unit Slot 1
    elseif GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then--PC
        Platform = 'PC'
        Now = 0x0714DB8 - 0x56454E
        Save = 0x09A7070 - 0x56450E
        Obj0 = 0x2A22B90 - 0x56450E
        Sys3 = 0x2A59DB0 - 0x56450E
        Btl0 = 0x2A74840 - 0x56450E
        Slot1 = 0x2A20C58 - 0x56450E
    end
end

function Events(M,B,E) --Check for Map, Btl, and Evt
    return ((Map == M or not M) and (Btl == B or not B) and (Evt == E or not E))
end

function Cheats()
local _CurrAnimPointer = ReadShort(ReadLong(0x00AD4218-0x56454E) + 0x180, true)
local _FoundArrayAnim
local RVCurrent = ReadFloat(ReadLong(0x56FD2A) + 0xD48, true)
local RVMax = ReadFloat(ReadLong(0x56FD2A) + 0xD4C, true)
	for i = 1, 30 do
        if _CurrAnimPointer ~= _BadAnimations[i] then
        _FoundArrayAnim = false
        end
    end
    for i = 1, 30 do 
        if _CurrAnimPointer == _BadAnimations[i] then
        _FoundArrayAnim = true
        end
    end
	if ReadByte(Slot1+0x180) > ReadByte(Slot1+0x184) then
	WriteByte(Slot1+0x180, ReadByte(Slot1+0x184))
	end
	if RVCurrent > UA and RVCurrent > 0 and _FoundArrayAnim == false then
		if ReadByte(Slot1+0x180) < ReadByte(Slot1+0x184) then
		WriteByte(Slot1+0x180, ReadByte(Slot1+0x180) + (RVCurrent - UA) / 4)
		end
	UA = RVCurrent
	elseif RVCurrent == 0 and _FoundArrayAnim == false then
	UA = 0
	end
end
