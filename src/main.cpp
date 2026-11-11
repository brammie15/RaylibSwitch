#include <cstdio>
#include <unistd.h>
#include <switch.h>

#include "raylib.h"
#include "raymath.h"

#include "BouncingLogo.hpp"

namespace
{
constexpr int kScreenWidth  = 1280;
constexpr int kScreenHeight = 720;

class NxlinkStdio
{
public:
    NxlinkStdio()
    {
        socketInitializeDefault();
        m_sock = nxlinkStdio();
        std::printf("Hello from the Switch! (nxlink socket %d)\n", m_sock);
    }
    ~NxlinkStdio()
    {
        if (m_sock >= 0) close(m_sock);
        socketExit();
    }
    NxlinkStdio(const NxlinkStdio&) = delete;
    NxlinkStdio& operator=(const NxlinkStdio&) = delete;

private:
    int m_sock = -1;
};
}

int main()
{
    NxlinkStdio stdio;

    InitWindow(kScreenWidth, kScreenHeight, "Raylib Switch");
    SetTargetFPS(60);

    {
        BouncingLogo logo("romfs:/raylib_logo.png", { kScreenWidth, kScreenHeight });

        while (!WindowShouldClose())
        {
            const float dt = GetFrameTime();

            Vector2 push = Vector2Zero();
            if (IsGamepadAvailable(0))
            {
                push = { GetGamepadAxisMovement(0, GAMEPAD_AXIS_LEFT_X),
                         GetGamepadAxisMovement(0, GAMEPAD_AXIS_LEFT_Y) };
                if (IsGamepadButtonPressed(0, GAMEPAD_BUTTON_MIDDLE_RIGHT)) break;
            }

            logo.Update(dt, push);

            BeginDrawing();
                ClearBackground(RAYWHITE);
                logo.Draw();
                DrawText("raylib on Nintendo Switch!", 40, 40, 40, DARKGRAY);
                DrawText("Left stick: push the logo   +: exit", 40, 90, 20, GRAY);
                DrawFPS(kScreenWidth - 100, 20);
            EndDrawing();
        }
    }

    CloseWindow();
    return 0;
}
