import pygame, sys
from pygame.locals import  *

#set up pygame
pygame.init()

#set up the window
windowSurface = pygame.display.set_mode((500, 400), 0, 32)
pygame.display.set_caption('Hello world!')

#set up the colors
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)


#draw the black background onto the windowSurface
windowSurface.fill(BLACK)

#load image
eyeShape = pygame.image.load('3eyecopy.png').convert()

windowSurface.blit(eyeShape,(30,130))

# draw a blue circle onto the surface
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