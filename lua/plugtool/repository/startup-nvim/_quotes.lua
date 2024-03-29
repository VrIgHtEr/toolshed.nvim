local quotes = {
    {
        'Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it.',
        '',
        '- Brian Kernighan',
    },
    {
        "If you don't fail at least 90% of the time, you're not aiming high enough.",
        '',
        '- Alan Kay',
    },
    {
        'Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.',
        '',
        '- John Woods',
    },
    {
        'Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.',
    },
    {
        "If you don't make mistakes, you're not working on hard enough problems.",
        '',
        '- Frank Wilczek',
    },
    {
        'Use tracer bullets to find the target.',
        '',
        'Tracer bullets let you home in on your target by trying things and seeing how close they land.',
    },
    {
        'Always design for concurrency.',
        '',
        "Allow for concurrency, and you'll design cleaner interfaces with fewer assumptions.",
    },
    {
        'Test your software, or your users will.',
        '',
        "Test ruthlessly. Don't make your users find bugs for you.",
    },
    {
        "Don't live with broken windows.",
        '',
        'Fix bad designs, wrong decisions, and poor code when you see them.',
    },
    {
        'Keep knowledge in plain text.',
        '',
        "Plain text won't become obsolete. It helps leverage your work and simplifies debugging and testing.",
    },
    {
        'Use a single editor well.',
        '',
        'The editor should be an extension of your hand; make sure your editor is configurable, extensible, and programmable.',
    },
    {
        'Crash early.',
        '',
        'A dead program normally does a lot less damage than a crippled one.',
    },
    {
        'Design to test.',
        '',
        'Start thinking about testing before you write a line of code.',
    },
    {
        'Work with a user to think like a user.',
        '',
        "It's the best way to gain insight into how the system will really be used.",
    },
    {
        'Test early. Test often. Test automatically.',
        '',
        'Tests that run with every build are much more effective than test plans that sit on a shelf.',
    },
    {
        'Use saboteurs to test your testing.',
        '',
        'Introduce bugs on purpose in a separate copy of the source to verify that testing will catch them.',
    },
    {
        "There's an old story about the person who wished his computer were as easy to use as his telephone. That wish has come true, since I no longer know how to use my telephone.",
        '',
        '- Bjarne Stroustrup',
    },
    {
        'There are only two industries that refer to their customers as "users".',
        '',
        '- Edward Tufte',
    },
    {
        'Easy things should be easy and hard things should be possible.',
        '',
        '- Larry Wall',
    },
    { 'They did not know it was impossible, so they did it!', '', '- Mark Twain' },
    {
        'If debugging is the process of removing bugs, then programming must be the process of putting them in.',
        '',
        '- Edsger W. Dijkstra',
    },
    {
        "The average user doesn't give a damn what happens, as long as (1) it works and (2) it's fast.",
        '',
        '- Daniel J. Bernstein',
    },
}

local string = require 'toolshed.util.string'

local function process_quotes(json)
    local q = vim.fn.json_decode(json)
    for i, x in ipairs(q) do
        local n = {}
        for l in string.lines(x.text) do
            table.insert(n, l)
        end
        if x.author ~= 'Unknown' then
            table.insert(n, '')
            table.insert(n, '- ' .. x.author)
        end
        q[i] = n
    end
    return q
end
local quotes2 = process_quotes('[' .. [[
    {
        "text": "Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.",
        "author": "Martin Golding"
    },
    {
        "text": "All computers wait at the same speed.",
        "author": "Unknown"
    },
    {
        "text": "A misplaced decimal point will always end up where it will do the greatest damage.",
        "author": "Unknown"
    },
    {
        "text": "A good programmer looks both ways before crossing a one-way street.",
        "author": "Unknown"
    },
    {
        "text": "A computer program does what you tell it to do, not what you want it to do.",
        "author": "Unknown"
    },
    {
        "text": "\"Intel Inside\" is a Government Warning required by Law.",
        "author": "Unknown"
    },
    {
        "text": "Common sense gets a lot of credit that belongs to cold feet.",
        "author": "Arthur Godfrey"
    },
    {
        "text": "Chuck Norris doesn’t go hunting. Chuck Norris goes killing.",
        "author": "Unknown"
    },
    {
        "text": "Chuck Norris counted to infinity... twice.",
        "author": "Unknown"
    },
    {
        "text": "C is quirky, flawed, and an enormous success.",
        "author": "Unknown"
    },
    {
        "text": "Beta is Latin for still doesn’t work.",
        "author": "Unknown"
    },
    {
        "text": "ASCII stupid question, get a stupid ANSI!",
        "author": "Unknown"
    },
    {
        "text": "Artificial Intelligence usually beats natural stupidity.",
        "author": "Unknown"
    },
    {
        "text": "Any fool can use a computer. Many do.",
        "author": "Ted Nelson"
    },
    {
        "text": "Hey! It compiles! Ship it!",
        "author": "Unknown"
    },
    {
        "text": "Hate cannot drive out hate; only love can do that.",
        "author": "Martin Luther King Junior"
    },
    {
        "text": "Guns don’t kill people. Chuck Norris kills people.",
        "author": "Unknown"
    },
    {
        "text": "God is real, unless declared integer.",
        "author": "Unknown"
    },
    {
        "text": "First, solve the problem. Then, write the code.",
        "author": "John Johnson"
    },
    {
        "text": "Experience is the name everyone gives to their mistakes.",
        "author": "Oscar Wilde"
    },
    {
        "text": "Every piece of software written today is likely going to infringe on someone else’s patent.",
        "author": "Miguel de Icaza"
    },
    {
        "text": "Computers make very fast, very accurate mistakes.",
        "author": "Unknown"
    },
    {
        "text": "Computers do not solve problems, they execute solutions.",
        "author": "Unknown"
    },
    {
        "text": "I have NOT lost my mind—I have it backed up on tape somewhere.",
        "author": "Unknown"
    },
    {
        "text": "If brute force doesn’t solve your problems, then you aren’t using enough.",
        "author": "Unknown"
    },
    {
        "text": "It works on my machine.",
        "author": "Unknown"
    },
    {
        "text": "Java is, in many ways, C++??.",
        "author": "Unknown"
    },
    {
        "text": "Keyboard not found...Press any key to continue.",
        "author": "Unknown"
    },
    {
        "text": "Life would be so much easier if we only had the source code.",
        "author": "Unknown"
    },
    {
        "text": "Mac users swear by their Mac, PC users swear at their PC.",
        "author": "Unknown"
    },
    {
        "text": "Microsoft is not the answer. Microsoft is the question. \"No\" is the answer.",
        "author": "Unknown"
    },
    {
        "text": "MS-DOS isn’t dead, it just smells that way.",
        "author": "Unknown"
    },
    {
        "text": "Only half of programming is coding. The other 90% is debugging.",
        "author": "Unknown"
    },
    {
        "text": "Pasting code from the Internet into production code is like chewing gum found in the street.",
        "author": "Unknown"
    },
    {
        "text": "Press any key to continue or any other key to quit.",
        "author": "Unknown"
    },
    {
        "text": "Profanity is the one language all programmers know best.",
        "author": "Unknown"
    },
    {
        "text": "The best thing about a boolean is even if you are wrong, you are only off by a bit.",
        "author": "Unknown"
    },
    {
        "text": "The nice thing about standards is that there are so many to choose from.",
        "author": "Unknown"
    },
    {
        "text": "There are 3 kinds of people: those who can count and those who can’t.",
        "author": "Unknown"
    },
    {
        "text": "There is no place like 127.0.0.1",
        "author": "Unknown"
    },
    {
        "text": "There is nothing quite so permanent as a quick fix.",
        "author": "Unknown"
    },
    {
        "text": "There’s no test like production.",
        "author": "Unknown"
    },
    {
        "text": "To err is human, but for a real disaster you need a computer.",
        "author": "Unknown"
    },
    {
        "text": "Ubuntu is an ancient African word, meaning \"can’t configure Debian\"",
        "author": "Unknown"
    },
    {
        "text": "UNIX is the answer, but only if you phrase the question very carefully.",
        "author": "Unknown"
    },
    {
        "text": "Usenet is a Mobius strand of spaghetti.",
        "author": "Unknown"
    },
    {
        "text": "Weeks of coding can save you hours of planning.",
        "author": "Unknown"
    },
    {
        "text": "When your computer starts falling apart, stop hitting it with a Hammer!",
        "author": "Unknown"
    },
    {
        "text": "Who is General Failure? And why is he reading my disk?",
        "author": "Unknown"
    },
    {
        "text": "You can stand on the shoulders of giants OR a big enough pile of dwarfs, works either way.",
        "author": "Unknown"
    },
    {
        "text": "You start coding. I’ll go find out what they want.",
        "author": "Unknown"
    },
    {
        "text": "I love deadlines. I like the whooshing sound they make as they fly by.",
        "author": "Douglas Adams"
    },
    {
        "text": "I think we agree, the past is over.",
        "author": "George W. Bush"
    },
    {
        "text": "In order to be irreplaceable, one must always be different.",
        "author": "Coco Chanel"
    },
    {
        "text": "In the future everyone will be famous for fifteen minutes.",
        "author": "Andy Warhol"
    },
    {
        "text": "In three words I can sum up everything I’ve learned about life: it goes on.",
        "author": "Robert Frost"
    },
    {
        "text": "It is a mistake to think you can solve any major problems just with potatoes.",
        "author": "Douglas Adams"
    },
    {
        "text": "It’s kind of fun to do the impossible.",
        "author": "Walt Disney"
    },
    {
        "text": "Java is to JavaScript what Car is to Carpet.",
        "author": "Chris Heilmann"
    },
    {
        "text": "Judge a man by his questions rather than by his answers.",
        "author": "Voltaire"
    },
    {
        "text": "Just don’t create a file called -rf.",
        "author": "Larry Wall"
    },
    {
        "text": "Knowledge is power.",
        "author": "Francis Bacon"
    },
    {
        "text": "Let’s call it an accidental feature.",
        "author": "Larry Wall"
    },
    {
        "text": "Linux is only free if your time has no value.",
        "author": "Jamie Zawinski"
    },
    {
        "text": "Measuring programming progress by lines of code is like measuring aircraft building progress by weight.",
        "author": "Bill Gates"
    },
    {
        "text": "Never trust a computer you can’t throw out a window.",
        "author": "Steve Wozniak"
    },
    {
        "text": "Nobody expects the Spanish inquisition.",
        "author": "Monty Python"
    },
    {
        "text": "On the Internet, nobody knows you’re a dog.",
        "author": "Peter Steiner"
    },
    {
        "text": "One man’s constant is another man’s variable.",
        "author": "Alan J. Perlis"
    },
    {
        "text": "People that hate cats will come back as mice in their next life.",
        "author": "Faith Resnick"
    },
    {
        "text": "Perl - The only language that looks the same before and after RSA encryption.",
        "author": "Keith Bostic"
    },
    {
        "text": "PHP – Yeah, you know me.",
        "author": "PHPaughty by PHPature"
    },
    {
        "text": "The future is here. It is just not evenly distributed yet.",
        "author": "William Gibson"
    },
    {
        "text": "The greatest performance improvement of all is when a system goes from not-working to working.",
        "author": "John Ousterhout"
    },
    {
        "text": "Software is like sex: It’s better when it’s free.",
        "author": "Linus Torvalds"
    },
    {
        "text": "Sour, sweet, bitter, pungent, all must be tasted.",
        "author": "Chinese Proverb"
    },
    {
        "text": "Stay hungry, stay foolish.",
        "author": "Whole Earth Catalog"
    },
    {
        "text": "The artist belongs to his work, not the work to the artist.",
        "author": "Novalis"
    },
    {
        "text": "The only \"intuitive\" interface is the nipple. After that it’s all learned.",
        "author": "Bruce Ediger"
    },
    {
        "text": "The only completely consistent people are the dead.",
        "author": "Aldous Huxley"
    },
    {
        "text": "The problem with troubleshooting is that trouble shoots back.",
        "author": "Unknown Author"
    },
    {
        "text": "The three great virtues of a programmer: laziness, impatience, and hubris.",
        "author": "Larry Wall"
    },
    {
        "text": "Time is an illusion. Lunchtime doubly so.",
        "author": "Douglas Adams"
    },
    {
        "text": "When debugging, novices insert corrective code; experts remove defective code.",
        "author": "Richard Pattis"
    },
    {
        "text": "When in doubt, leave it out.",
        "author": "Joshua Bloch"
    },
    {
        "text": "Walking on water and developing software from a specification are easy if both are frozen.",
        "author": "Edward V Berard"
    },
    {
        "text": "We cannot learn without pain.",
        "author": "Aristotle"
    },
    {
        "text": "We have always been shameless about stealing great ideas.",
        "author": "Steve Jobs"
    },
    {
        "text": "You can kill a man but you can’t kill an idea.",
        "author": "Medgar Evers"
    },
    {
        "text": "You can never underestimate the stupidity of the general public.",
        "author": "Scott Adams"
    },
    {
        "text": "You must have chaos in your soul to give birth to a dancing star.",
        "author": "Friedrich Nietzsche"
    },
    {
        "text": "Without requirements or design, programming is the art of adding bugs to an empty \"text\" file.",
        "author": "Louis Srygley"
    },
    {
        "text": "Sometimes it pays to stay in bed on Monday, rather than spending the rest of the week debugging Monday’s code.",
        "author": "Dan Salomon"
    },
    {
        "text": "You miss 100 percent of the shots you never take.",
        "author": "Wayne Gretzky"
    },
    {
        "text": "One of the biggest problems that software developers face is that technology changes rapidly. It is very hard to stay current.",
        "author": "Vivek Wadhwa"
    },
    {
        "text": "Ideas want to be ugly.",
        "author": "Jason Santa Maria"
    },
    {
        "text": "Developer: an organism that turns coffee into code.",
        "author": "Unknown"
    },
    {
        "text": "One man´s crappy software is another man´s full time job.",
        "author": "Jessica Gaston"
    },
    {
        "text": "It´s okay to figure out murder mysteries, but you shouldn´t need to figure out code. You should be able to read it.",
        "author": "Steve McConnell"
    },
    {
        "text": "Programming languages, like pizzas, come in only two sizes: too big and too small.",
        "author": "Richard Pattis"
    },
    {
        "text": "Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the universe trying to produce bigger and better idiots. So far, the universe is winning.",
        "author": "Rich Cook"
    },
    {
        "text": "Plan to throw one (implementation) away; you will, anyhow.",
        "author": "Fred Brooks"
    },
    {
        "text": "Every good work of software starts by scratching a developer´s personal itch",
        "author": "Unknown"
    },
    {
        "text": "Perfection (in design) is achieved not when there is nothing more to add, but rather when there is nothing more to take away.",
        "author": "Antoine de Saint-Exupery"
    },
    {
        "text": "Prolific programmers contribute to certain disaster.",
        "author": "Niklaus Wirth"
    },
    {
        "text": "Programming can be fun, so can cryptography; however they should not be combined.",
        "author": "Kreitzberg and Shneiderman"
    },
    {
        "text": "It´s better to wait for a productive programmer to become available than it is to wait for the first available programmer to become productive.",
        "author": "Steve McConnell"
    },
    {
        "text": "An organization that treats its programmers as morons will soon have programmers that are willing and able to act like morons only.",
        "author": "Bjarne Stroustrup"
    },
    {
        "text": "Real programmers can write assembly code in any language.",
        "author": "Larry Wall"
    },
    {
        "text": "The key to performance is elegance, not battalions of special cases.",
        "author": "Jon Bentley, Doug McIlroy"
    },
    {
        "text": "Inside every large program, there is a program trying to get out.",
        "author": "C.A.R. Hoare"
    },
    {
        "text": "Why do we never have time to do it right, but always have time to do it over?",
        "author": "Unknown"
    },
    {
        "text": "The goal of Computer Science is to build something that will last at least until we´ve finished building it. ",
        "author": "Unknown"
    },
    {
        "text": "A good way to stay flexible is to write less code.",
        "author": "Pragmatic Programmer"
    },
    {
        "text": "No matter what the problem is, it´s always a people problem.",
        "author": "Gerald M. Weinberg"
    },
    {
        "text": "Every big computing disaster has come from taking too many ideas and putting them in one place.",
        "author": "Gordon Bell"
    },
    {
        "text": "Adding manpower to a late software project makes it later!",
        "author": "Fred Brooks"
    },
    {
        "text": "The best way to get a project done faster is to start sooner",
        "author": "Jim Highsmith"
    },
    {
        "text": "Even the best planning is not so omniscient as to get it right the first time.",
        "author": "Fred Brooks"
    },
    {
        "text": "All you need is love. But a new pair of shoes never hurt anybody.",
        "author": "Unknown"
    },
    {
        "text": "The best revenge is massive success.",
        "author": "Frank Sinatra"
    },
    {
        "text": "Reality itself is too obvious to be true.",
        "author": "Jean Baudrillard"
    },
    {
        "text": "Be yourself; everyone else is already taken.",
        "author": "Oscar Wilde"
    },
    {
        "text": "Let me just change this one line of code…",
        "author": "Unknown"
    },
    {
        "text": "Fast, Good, Cheap. Pick two.",
        "author": "Unknown"
    },
    {
        "text": "Did you know? The collective noun for a group of programmers is a merge-conflict.",
        "author": "Unknown"
    },
    {
        "text": "If there is no struggle, there is no progress.",
        "author": "Frederick Douglass"
    },
    {
        "text": "You have to learn the rules of the game. And then you have to play better than anyone else.",
        "author": "Albert Einstein"
    },
    {
        "text": "Learn from yesterday, live for today, hope for tomorrow. The important thing is not to stop questioning.",
        "author": "Albert Einstein"
    },
    {
        "text": "Insanity: doing the same thing over and over again and expecting different results.",
        "author": "Albert Einstein"
    },
    {
        "text": "A person who never made a mistake never tried anything new.",
        "author": "Albert Einstein"
    },
    {
        "text": "Logic will get you from A to B. Imagination will take you everywhere.",
        "author": "Albert Einstein"
    },
    {
        "text": "When the solution is simple, God is answering.",
        "author": "Albert Einstein"
    },
    {
        "text": "If you can´t explain it simply, you don´t understand it well enough.",
        "author": "Albert Einstein"
    },
    {
        "text": "If the facts don´t fit the theory, change the facts.",
        "author": "Albert Einstein"
    },
    {
        "text": "It is a miracle that curiosity survives formal education.",
        "author": "Albert Einstein"
    },
    {
        "text": "I only believe in statistics that I doctored myself.",
        "author": "Winston S. Churchill?"
    },
    {
        "text": "Men and nations behave wisely when they have exhausted all other resources.",
        "author": "Abba Eban"
    },
    {
        "text": "If you´re going through hell, keep going.",
        "author": "Unknown"
    },
    {
        "text": "Success is not forever and failure isn´t fatal.",
        "author": "Don Shula"
    },
    {
        "text": "I have never let my schooling interfere with my education.",
        "author": "Mark Twain"
    },
    {
        "text": "The secret of getting ahead is getting started.",
        "author": "Mark Twain"
    },
    {
        "text": "Get your facts first, then you can distort them as you please.",
        "author": "Mark Twain"
    },
    {
        "text": "Apparently there is nothing that cannot happen today.",
        "author": "Mark Twain"
    },
    {
        "text": "Plans are worthless, but planning is everything.",
        "author": "Dwight D. Eisenhower"
    },
    {
        "text": "Before you marry a person you should first make them use a computer with slow Internet to see who they really are.",
        "author": "Will Ferrell"
    },
    {
        "text": "I just invent, then wait until man comes around to needing what I´ve invented.",
        "author": "R. Buckminster Fuller"
    },
    {
        "text": "The best way to make your dreams come true is to wake up.",
        "author": "Muriel Siebert"
    },
    {
        "text": "If you can't write it down in English, you can't code it.",
        "author": "Peter Halpern"
    },
    {
        "text": "Suspicion is healthy. It’ll keep you alive.",
        "author": "Laurell K. Hamilton"
    },
    {
        "text": "If your parents never had children, chances are you won’t, either.",
        "author": "Dick Cavett"
    },
    {
        "text": "Sometimes I think we´re alone in the universe & sometimes I think we´re not. In either case the idea is quite staggering",
        "author": "Arthur C. Clarke"
    },
    {
        "text": "Talk is cheap, show me the code!",
        "author": "Linus Torvalds"
    },
    {
        "text": "They did not know it was impossible, so they did it!",
        "author": "Mark Twain"
    },
    {
        "text": "You are what you share.",
        "author": "Charles Leadbeater"
    },
    {
        "text": "You want it in one line? Does it have to fit in 80 columns?",
        "author": "Larry Wall"
    },
    {
        "text": "The Internet? Is that thing still around?",
        "author": "Homer Simpson"
    },
    {
        "text": "The journey is the destination.",
        "author": "Dan Eldon"
    },
    {
        "text": "OO programming offers a sustainable way to write spaghetti code. It lets you accrete programs as a series of patches.",
        "author": "Paul Graham"
    },
    {
        "text": "Ruby is rubbish! PHP is phpantastic!",
        "author": "Nikita Popov"
    },
    {
        "text": "So long and thanks for all the fish!",
        "author": "Douglas Adams"
    },
    {
        "text": "If I had more time, I would have written a shorter letter.",
        "author": "Cicero"
    },
    {
        "text": "The best reaction to \"this is confusing, where are the docs\" is to rewrite the feature to make it less confusing, not write more docs.",
        "author": "Jeff Atwood"
    },
    {
        "text": "The older I get, the more I believe that the only way to become a better programmer is by not programming.",
        "author": "Jeff Atwood"
    },
    {
        "text": "\"That hardly ever happens\" is another way of saying \"it happens\".",
        "author": "Douglas Crockford"
    },
    {
        "text": "Hello, PHP, my old friend.",
        "author": "Anna Debenham"
    },
    {
        "text": "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations.",
        "author": "Melvin Conway"
    },
    {
        "text": "In design, complexity is toxic.",
        "author": "Melvin Conway"
    },
    {
        "text": "Good is the enemy of great, but great is the enemy of shipped.",
        "author": "Jeffrey Zeldman"
    },
    {
        "text": "Don't make the user provide information that the system already knows.",
        "author": "Rick Lemons"
    },
    {
        "text": "You're bound to be unhappy if you optimize everything.",
        "author": "Donald E. Knuth"
    },
    {
        "text": "If the programmers like each other, they play a game called 'pair programming'. And if not then the game is called 'peer review'.",
        "author": "Anna Nachesa"
    },
    {
        "text": "Simplicity is prerequisite for reliability.",
        "author": "Edsger W. Dijkstra"
    },
    {
        "text": "Focus on WHY instead of WHAT in your code will make you a better developer",
        "author": "Jordi Boggiano"
    },
    {
        "text": "The best engineers I know are artists at heart. The best designers I know are secretly technicians as well.",
        "author": "Andrei Herasimchuk"
    },
    {
        "text": "Poor management can increase software costs more rapidly than any other factor.",
        "author": "Barry Boehm"
    },
    {
        "text": "If you can't deploy your services independently then they aren't microservices.",
        "author": "Daniel Bryant"
    },
    {
        "text": "No one hates software more than software developers.",
        "author": "Jeff Atwood"
    },
    {
        "text": "The proper use of comments is to compensate for our failure to express ourself in code.",
        "author": "Robert C. Martin"
    },
    {
        "text": "Code is like humor. When you have to explain it, it's bad.",
        "author": "Cory House"
    },
    {
        "text": "Fix the cause, not the symptom.",
        "author": "Steve Maguire"
    },
    {
        "text": "Programmers are constantly making things more complicated than they need to be BECAUSE FUTURE. Fuck the future. Program for today.",
        "author": "David Heinemeier Hansson"
    },
    {
        "text": "People will realize that software is not a product; you use it to build a product.",
        "author": "Linus Torvalds"
    },
    {
        "text": "Design is choosing how you will fail.",
        "author": "Ron Fein"
    },
    {
        "text": "Focus is saying no to 1000 good ideas.",
        "author": "Steve Jobs"
    },
    {
        "text": "Code never lies, comments sometimes do.",
        "author": "Ron Jeffries"
    },
    {
        "text": "Be careful with each other, so you can be dangerous together.",
        "author": "Unknown"
    },
    {
        "text": "When making a PR to a major project, you have to \"sell\" that feature \/ contribution. You have to be convincing on why it belongs there. The maintainer is going to be the one babysitting that code forever.",
        "author": "Taylor Otwell"
    },
    {
        "text": "Be the change you wish was made. Share the lessons you wish you'd been taught. Make the sacrifices you wish others had made.",
        "author": "David Heinemeier Hansson"
    },
    {
        "text": "The only way to achieve flexibility is to make things as simple and easy to change as you can.",
        "author": "Casey Brant"
    },
    {
        "text": "The computer was born to solve problems that did not exist before.",
        "author": "Bill Gates"
    },
    {
        "text": "People don't care about what you say, they care about what you build.",
        "author": "Mark Zuckerberg"
    },
    {
        "text": "We will not ship shit.",
        "author": "Robert C. Martin"
    }
]] .. ']')

for _, x in ipairs(quotes2) do
    table.insert(quotes, x)
end
return quotes
