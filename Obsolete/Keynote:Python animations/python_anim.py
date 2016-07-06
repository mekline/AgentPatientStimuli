import pygame, sys, time
from pygame.locals import  *

#set up pygame
pygame.init()

#set up the window
WINDOWWIDTH = 400
WINDOWHEIGHT = 400
windowSurface = pygame.display.set_mode((WINDOWWIDTH, WINDOWHEIGHT), 0, 32)
pygame.display.set_caption('Animation') #Caption on top of window

#set up direction variables
RIGHT = 1
LEFT = 2
UP = 3
DOWN = 4

#Establish movement speed
MOVESPEED = 4

#set up the colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)


#draw the black background onto the windowSurface
windowSurface.fill(BLACK)

#load image of agent
eyeShape = pygame.image.load('3eyecopy.png').convert()

windowSurface.blit(eyeShape,(30,130))

# draw a blue circle onto the surface (this is the patient)
pygame.draw.circle(windowSurface, BLUE, (300, 180), 50, 0)


# get a pixel array of the surface
pixArray = pygame.PixelArray(windowSurface)
pixArray[480][380] = BLACK
del pixArray

# draw the window onto the screen
pygame.display.update()

# run the game loop
while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()

