// Import and register all your controllers from the importmap under controllers/*

import { application } from './application'
import RevolutCardController from './revolut_card_controller'

application.register('revolut-card', RevolutCardController)
