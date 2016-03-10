import pygame, sys, time
from pygame.locals import *

pygame.init()

WINDOW_WIDTH = 750
WINDOW_HEIGHT = 500
windowSurface = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT), 0, 32)
pygame.display.set_caption('Animation')

LEFT = 1
RIGHT = 3

AGENT_START_X = 100
PATIENT_START_X = 300

MOVESPEED = 4

BLACK = (0, 0, 0)
RED = (255, 0, 0)
GREEN = (0, 255, 0)
BLUE = (0, 0, 255)

eyeShape = pygame.image.load('3eyecopy.png').convert() #Defines image

class Block(pygame.sprite.Sprite):
    def __init__(self,x,y):
        super(Block, self).__init__() # Initiates Sprite constructor
        self.image = eyeShape
        self.rect = self.image.get_rect()
        self.image.set_colorkey(BLACK)

block_list = pygame.sprite.Group()

agentblock = Block(100,50)
patientblock = Block(200,50)
agentblock.rect.x = AGENT_START_X
agentblock.rect.y = 100
patientblock.rect.x = PATIENT_START_X
patientblock.rect.y = 100
agent = {'rect':agentblock.rect,'dir':RIGHT}
patient = {'rect':patientblock.rect,'dir':RIGHT}

#run the main loop
while True:
    for event in pygame.event.get():
        if event.type == QUIT:
            pygame.quit()
            sys.exit()
    #Quits once both blocks leave the screen
    if agent['rect'].left > WINDOW_WIDTH:
        pygame.quit()
        sys.exit()

    windowSurface.fill(BLACK)

    #Agent movement

    if agent['dir'] == LEFT:
        agent['rect'].left -= MOVESPEED
    if agent['dir'] == RIGHT:
        agent['rect'].left += MOVESPEED

    #turn around if it hits the end - won't be needed later, possibly modify though
    if agent['rect'].left < 0:
        agent['dir'] == RIGHT

    #same
    if agent['rect'].right > WINDOW_WIDTH:
        agent['dir'] == LEFT

    #draw the agent
    windowSurface.blit(eyeShape,(agent['rect'].left, agent['rect'].top))





    #Patient movement
    if agent['rect'].right > PATIENT_START_X:
        if patient['dir'] == LEFT:
            patient['rect'].left -= MOVESPEED
        if patient['dir'] == RIGHT:
            patient['rect'].left += MOVESPEED

        #turn around if it hits the end - won't be needed later, possibly modify though
        if patient['rect'].left < 0:
            patient['dir'] == RIGHT

        #same
        if patient['rect'].right > WINDOW_WIDTH:
            patient['dir'] == LEFT

    #draw the patient
    windowSurface.blit(eyeShape,(patient['rect'].left, patient['rect'].top))




    #draw the window
    pygame.display.update()
    time.sleep(0.02)



    #Make some stuff transparent
    #Figure out how to adjust height
    #Get the arms going
    #Get some interesting movements going