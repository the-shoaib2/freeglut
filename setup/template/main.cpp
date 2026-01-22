#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <cstdlib>
#include <string>

/* Fix for Windows: GL_MULTISAMPLE might be missing in default headers */
#ifndef GL_MULTISAMPLE
#define GL_MULTISAMPLE  0x809D
#endif

/* Animation state */
static double angle = 0.0;

/* ---------- Helper: Render Bitmap Text ---------- */
void renderText(float x, float y, void *font, const char *string)
{
    const char *c;
    glRasterPos2f(x, y);
    for (c = string; *c != '\0'; c++) {
        glutBitmapCharacter(font, *c);
    }
}

/* ---------- Resize ---------- */
static void resize(int width, int height)
{
    if (height == 0) height = 1;
    float aspect = (float)width / (float)height;

    glViewport(0, 0, width, height);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, aspect, 1.0, 100.0);

    glMatrixMode(GL_MODELVIEW);
}

/* ---------- Display ---------- */
static void display(void)
{
    static double lastTime = 0.0;
    double currentTime = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
    double delta = currentTime - lastTime;
    lastTime = currentTime;

    angle += 60.0 * delta;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();

    // 1. Render 3D Scene (The Diamond)
    gluLookAt(
        0.0, 0.0, 5.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0
    );

    // Light Position
    GLfloat light_position[] = { 2.0f, 2.0f, 5.0f, 1.0f };
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);

    glPushMatrix();
        // Rotate the diamond
        glRotated(angle, 0, 1, 0);
        glRotated(30, 1, 0, 1); // Slight tilt

        // Material Color (Cyan/Blueish)
        glColor3f(0.0f, 0.8f, 1.0f);
        glutSolidOctahedron(); // Octahedron looks like a diamond
        
        // White wireframe overlay for style
        glColor3f(1.0f, 1.0f, 1.0f);
        glutWireOctahedron();
    glPopMatrix();

    // 2. Render 2D Overlay (Text)
    // Switch to orthographic projection for 2D UI
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    gluOrtho2D(0, glutGet(GLUT_WINDOW_WIDTH), 0, glutGet(GLUT_WINDOW_HEIGHT));
    
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
    glDisable(GL_LIGHTING); // Disable lighting for text
    glDisable(GL_DEPTH_TEST);

    // Bottom-center text
    glColor3f(1.0f, 1.0f, 1.0f); // White text
    std::string text = "FreeGLUT by the-shoaib2";
    int textWidth = 0;
    for(char c : text) textWidth += glutBitmapWidth(GLUT_BITMAP_HELVETICA_18, c);
    
    float xPos = (glutGet(GLUT_WINDOW_WIDTH) - textWidth) / 2.0f;
    float yPos = 30.0f; // Padding from bottom

    renderText(xPos, yPos, GLUT_BITMAP_HELVETICA_18, text.c_str());

    // Restore 3D settings
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glPopMatrix();
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);

    glutSwapBuffers();
}

/* ---------- Keyboard ---------- */
static void key(unsigned char key, int, int)
{
    switch (key)
    {
        case 27:
        case 'q':
            exit(0);
            break;
    }
}

/* ---------- Idle ---------- */
static void idle(void)
{
    glutPostRedisplay();
}

/* ---------- Lighting ---------- */
const GLfloat light_ambient[]  = { 0.2f, 0.2f, 0.2f, 1.0f };
const GLfloat light_diffuse[]  = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };

const GLfloat mat_ambient[]    = { 0.3f, 0.3f, 0.3f, 1.0f };
const GLfloat mat_diffuse[]    = { 0.6f, 0.6f, 1.0f, 1.0f };
const GLfloat mat_specular[]   = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat mat_shininess[]  = { 64.0f };

/* ---------- Main ---------- */
int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH | GLUT_MULTISAMPLE);
    glutInitWindowSize(800, 600);
    glutCreateWindow("FreeGLUT Project");

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(key);
    glutIdleFunc(idle);

    glClearColor(0.1f, 0.12f, 0.15f, 1.0f); // Dark elegant background

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_MULTISAMPLE);
    
    // Enable blending for potential text niceties
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_NORMALIZE);

    // Setup lights
    glLightfv(GL_LIGHT0, GL_AMBIENT,  light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);

    // Setup material
    glMaterialfv(GL_FRONT, GL_AMBIENT,   mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,   mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR,  mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);

    glutMainLoop();
    return 0;
}
