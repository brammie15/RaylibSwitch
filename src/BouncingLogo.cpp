#include "BouncingLogo.hpp"

#include "raymath.h"

BouncingLogo::BouncingLogo(const char* texturePath, Vector2 bounds)
    : m_texture(LoadTexture(texturePath))
    , m_bounds(bounds)
    , m_pos(Vector2Scale(bounds, 0.5f))
{
}

BouncingLogo::~BouncingLogo()
{
    UnloadTexture(m_texture);
}

void BouncingLogo::Update(float dt, Vector2 push)
{
    m_vel = Vector2Add(m_vel, Vector2Scale(push, 600.0f * dt));
    m_pos = Vector2Add(m_pos, Vector2Scale(m_vel, dt));

    const float hw = m_texture.width  * 0.5f;
    const float hh = m_texture.height * 0.5f;

    if (m_pos.x < hw || m_pos.x > m_bounds.x - hw)
    {
        m_vel.x = -m_vel.x;
        m_pos.x = Clamp(m_pos.x, hw, m_bounds.x - hw);
    }
    if (m_pos.y < hh || m_pos.y > m_bounds.y - hh)
    {
        m_vel.y = -m_vel.y;
        m_pos.y = Clamp(m_pos.y, hh, m_bounds.y - hh);
    }
}

void BouncingLogo::Draw() const
{
    const Vector2 topLeft = { m_pos.x - m_texture.width * 0.5f, m_pos.y - m_texture.height * 0.5f };
    DrawTextureV(m_texture, topLeft, WHITE);
}
