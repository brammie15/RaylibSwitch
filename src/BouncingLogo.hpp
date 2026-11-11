#pragma once

#include "raylib.h"

class BouncingLogo
{
public:
    BouncingLogo(const char* texturePath, Vector2 bounds);
    ~BouncingLogo();

    BouncingLogo(const BouncingLogo&) = delete;
    BouncingLogo& operator=(const BouncingLogo&) = delete;

    void Update(float dt, Vector2 push);
    void Draw() const;

private:
    Texture2D m_texture{};
    Vector2   m_bounds{};
    Vector2   m_pos{};
    Vector2   m_vel{ 300.0f, 220.0f };
};
