/*
 * TestComponent.h - Component for WindowsTestProject
 */

#ifndef TESTCOMPONENT_H
#define TESTCOMPONENT_H

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

class TestComponent {
public:
    TestComponent();
    void draw();
};

#endif
