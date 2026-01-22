#ifndef SOLAR_SYSTEM_H
#define SOLAR_SYSTEM_H

#ifdef APPLE
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <vector>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

struct Star {
  float x, y, z;
};

struct PlanetConfig {
  const char *name;
  float orbitRadius;
  float orbitSpeed;
  float size;
  float r, g, b;
  bool hasRings;
};

static std::vector<Star> stars;
static int slices = 40;
static int stacks = 40;

static PlanetConfig solarSystem[] = {
    {"Mercury", 5.0f, 47.8f, 0.4f, 0.7f, 0.7f, 0.7f, false},
    {"Venus", 7.5f, 35.0f, 0.9f, 0.9f, 0.6f, 0.2f, false},
    {"Earth", 10.5f, 29.8f, 1.0f, 0.1f, 0.4f, 0.9f, false}, // Deep blue
    {"Mars", 14.0f, 24.1f, 0.7f, 0.9f, 0.3f, 0.1f, false},
    {"Jupiter", 20.0f, 13.1f, 2.5f, 0.8f, 0.6f, 0.4f, false},
    {"Saturn", 28.0f, 9.7f, 2.1f, 0.9f, 0.8f, 0.5f, true},
    {"Uranus", 34.0f, 6.8f, 1.2f, 0.6f, 0.8f, 0.9f, false},
    {"Neptune", 39.0f, 5.4f, 1.1f, 0.2f, 0.3f, 0.9f, false}};

static void initGalaxy(int count) {
  srand(time(NULL));
  stars.clear();
  for (int i = 0; i < count; i++) {
    float x = (rand() % 600) - 300;
    float y = (rand() % 600) - 300;
    float z = (rand() % 600) - 300;
    stars.push_back({x, y, z});
  }
}

static void renderText(float x, float y, const char *text, int charLimit = -1) {
  glDisable(GL_LIGHTING);
  glDisable(GL_DEPTH_TEST);
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glLoadIdentity();
  int w = glutGet(GLUT_WINDOW_WIDTH);
  int h = glutGet(GLUT_WINDOW_HEIGHT);
  gluOrtho2D(0, w, 0, h);
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glLoadIdentity();

  // Shadow for text (fake bold)
  glColor3f(0.0f, 0.1f, 0.2f);
  glRasterPos2f(x + 1, y - 1);
  int count = 0;
  for (const char *c = text; *c != '\0'; c++) {
    if (charLimit != -1 && count >= charLimit)
      break;
    glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, *c);
    count++;
  }

  glColor3f(1.0f, 1.0f, 1.0f); // Pure White
  glRasterPos2f(x, y);
  count = 0;
  for (const char *c = text; *c != '\0'; c++) {
    if (charLimit != -1 && count >= charLimit)
      break;
    glutBitmapCharacter(GLUT_BITMAP_HELVETICA_18, *c);
    count++;
  }

  glPopMatrix();
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glMatrixMode(GL_MODELVIEW);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_LIGHTING);
}

static void drawSphere(float radius, float r, float g, float b) {
  glColor3f(r, g, b);
  glutSolidSphere(radius, slices, stacks);
}

static void drawRings(float radius) {
  glDisable(GL_LIGHTING);
  glPushMatrix();
  glRotatef(70, 1, 0, 0); // Tilt rings
  glColor4f(0.6f, 0.5f, 0.4f, 0.5f);
  for (float i = radius + 0.5f; i < radius + 1.5f; i += 0.05f) {
    glBegin(GL_LINE_LOOP);
    for (int j = 0; j < 100; j++) {
      float angle = 2.0f * M_PI * j / 100.0f;
      glVertex3f(cos(angle) * i, sin(angle) * i, 0);
    }
    glEnd();
  }
  glPopMatrix();
  glEnable(GL_LIGHTING);
}

static void drawStars() {
  glDisable(GL_LIGHTING);
  glPointSize(1.2f);
  glBegin(GL_POINTS);
  for (const auto &s : stars) {
    float brightness = (rand() % 50 + 50) / 100.0f;
    glColor3f(brightness, brightness, brightness);
    glVertex3f(s.x, s.y, s.z);
  }
  glEnd();
  glEnable(GL_LIGHTING);
}

static void drawOrbit(float radius, float r, float g, float b) {
  glDisable(GL_LIGHTING);
  glLineWidth(1.0f); // Thin lines
  glBegin(GL_LINE_LOOP);
  glColor4f(1.0f, 1.0f, 1.0f, 0.2f); // Subtle White
  for (int i = 0; i < 200; i++) {
    float angle = 2.0f * M_PI * i / 200.0f;
    glVertex3f(cos(angle) * radius, 0, sin(angle) * radius);
  }
  glEnd();
  glEnable(GL_LIGHTING);
}

// Render branding with typing animation (minimalist)
static void renderBranding() {
  long currentTime = glutGet(GLUT_ELAPSED_TIME);
  int charsToShow = (int)(currentTime / 40);

  const char *devName = "Developer: MD Shoaib Khan";
  const char *gitLink = "github.com/the-shoaib2";
  int nameLen = strlen(devName);

  int w = glutGet(GLUT_WINDOW_WIDTH);
  int h = glutGet(GLUT_WINDOW_HEIGHT);

  int panelWidth = 320;
  int padding = w < 800 ? 10 : 20;

  int xPos = w - panelWidth - padding;
  int yPos = padding;

  if (xPos < padding)
    xPos = padding;

  // Render text relative to corner (No background panel)
  renderText(xPos + 12, yPos + 32, devName, charsToShow);
  if (charsToShow > nameLen)
    renderText(xPos + 12, yPos + 12, gitLink, charsToShow - nameLen);
}

#endif // SOLAR_SYSTEM_H
