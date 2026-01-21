#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

#include <cstdlib>

/* Geometry quality */
static int slices = 48;
static int stacks = 48;

/* Animation state */
static double angle = 0.0;

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
    gluLookAt(
        0.0, 0.0, 10.0,
        0.0, 0.0, 0.0,
        0.0, 1.0, 0.0
    );

    glColor3f(0.9f, 0.2f, 0.2f);

    glPushMatrix();
        glTranslated(-2.5, 1.3, 0);
        glRotated(angle, 0, 1, 0);
        glutSolidSphere(1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(0, 1.3, 0);
        glRotated(angle, 1, 0, 0);
        glutSolidCone(1, 1.5, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(2.5, 1.3, 0);
        glRotated(angle, 0, 0, 1);
        glutSolidTorus(0.25, 0.8, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(-2.5, -1.3, 0);
        glRotated(angle, 1, 1, 0);
        glutWireSphere(1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(0, -1.3, 0);
        glRotated(angle, 0, 1, 1);
        glutWireCone(1, 1.5, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(2.5, -1.3, 0);
        glRotated(angle, 1, 0, 1);
        glutWireTorus(0.25, 0.8, slices, stacks);
    glPopMatrix();

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

        case '+':
            slices += 4;
            stacks += 4;
            break;

        case '-':
            if (slices > 8 && stacks > 8)
            {
                slices -= 4;
                stacks -= 4;
            }
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
const GLfloat light_diffuse[]  = { 0.9f, 0.9f, 0.9f, 1.0f };
const GLfloat light_specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_position[] = { 5.0f, 5.0f, 10.0f, 1.0f };

const GLfloat mat_ambient[]    = { 0.3f, 0.3f, 0.3f, 1.0f };
const GLfloat mat_diffuse[]    = { 0.8f, 0.8f, 0.8f, 1.0f };
const GLfloat mat_specular[]   = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat mat_shininess[]  = { 128.0f };

/* ---------- Main ---------- */
int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH | GLUT_MULTISAMPLE);
    glutInitWindowSize(900, 600);
    glutCreateWindow("Smooth GLUT Shapes");

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(key);
    glutIdleFunc(idle);

    glClearColor(0.08f, 0.09f, 0.12f, 1.0f);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);

    glEnable(GL_MULTISAMPLE);
    glEnable(GL_LINE_SMOOTH);
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);

    glShadeModel(GL_SMOOTH);

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_NORMALIZE);

    glLightfv(GL_LIGHT0, GL_AMBIENT,  light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);

    glMaterialfv(GL_FRONT, GL_AMBIENT,   mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,   mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR,  mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);

    glutMainLoop();
    return 0;
}
