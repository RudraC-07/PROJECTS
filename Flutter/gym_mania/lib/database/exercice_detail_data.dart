import 'package:sqflite/sqflite.dart';

class ExerciseDetailData {
  Future insertExerciseDetails(Database db) async {
    // Instructions for each exercise - Comprehensive data for all 60 exercises
    final Map<int, List<String>> exerciseInstructions = {
      1: [ // Push Up
        'Start in a plank position with hands slightly wider than shoulder-width apart.',
        'Keep your body in a straight line from head to heels.',
        'Lower your chest towards the ground by bending your elbows.',
        'Push back up to the starting position.',
        'Repeat for desired repetitions.',
      ],
      2: [ // Barbell Bench Press
        'Lie flat on a bench with feet firmly planted on the ground.',
        'Grip the barbell with hands slightly wider than shoulder-width.',
        'Unrack the bar and position it over your chest.',
        'Lower the bar slowly to your chest.',
        'Press the bar back up to the starting position.',
        'Rack the bar safely when finished.',
      ],
      3: [ // Dumbbell Flyes
        'Lie on a flat bench holding dumbbells above your chest.',
        'Keep a slight bend in your elbows throughout the movement.',
        'Lower the weights in a wide arc until you feel a stretch in your chest.',
        'Squeeze your chest muscles to bring the weights back together.',
        'Control the movement both up and down.',
      ],
      4: [ // Incline Push Up
        'Place your hands on an elevated surface like a bench or step.',
        'Position your body in a straight line from head to heels.',
        'Lower your chest towards the elevated surface.',
        'Push back up to the starting position.',
        'Keep your core engaged throughout the movement.',
      ],
      5: [ // Decline Bench Press
        'Set up on a decline bench with your feet secured.',
        'Grip the barbell with hands slightly wider than shoulder-width.',
        'Lower the bar to your lower chest area.',
        'Press the bar back up to full arm extension.',
        'Maintain control throughout the entire range of motion.',
      ],
      6: [ // Chest Dips
        'Grip parallel bars and lift yourself up to starting position.',
        'Lean slightly forward to target the chest.',
        'Lower your body by bending your elbows.',
        'Descend until you feel a stretch in your chest.',
        'Push back up to the starting position.',
      ],
      7: [ // Cable Crossover
        'Set cables to high position and grab handles.',
        'Step forward with one foot for stability.',
        'Bring handles together in front of your chest in an arc motion.',
        'Squeeze your chest muscles at the peak contraction.',
        'Slowly return to starting position with control.',
      ],
      8: [ // Machine Chest Press
        'Adjust the seat height so handles are at chest level.',
        'Sit with your back firmly against the pad.',
        'Grip the handles with palms facing down.',
        'Press the handles forward until arms are extended.',
        'Slowly return to starting position.',
      ],
      9: [ // Plyometric Push Up
        'Start in a standard push-up position.',
        'Lower your chest to the ground as in a regular push-up.',
        'Explosively push up so your hands leave the ground.',
        'Land softly and immediately go into the next repetition.',
        'Focus on explosive power and soft landings.',
      ],
      10: [ // Close-Grip Push Up
        'Start in a push-up position with hands close together.',
        'Form a diamond shape with your thumbs and index fingers.',
        'Keep your body in a straight line.',
        'Lower your chest towards your hands.',
        'Push back up focusing on tricep engagement.',
      ],
      11: [ // Squat
        'Stand with feet shoulder-width apart.',
        'Keep your chest up and core engaged.',
        'Lower down as if sitting back into a chair.',
        'Keep your knees aligned with your toes.',
        'Lower until thighs are parallel to the ground.',
        'Drive through your heels to return to standing.',
      ],
      12: [ // Lunges
        'Stand with feet hip-width apart.',
        'Step forward with one leg into a lunge position.',
        'Lower your hips until both knees are at 90-degree angles.',
        'Push back to starting position.',
        'Alternate legs or complete one side before switching.',
      ],
      13: [ // Leg Press Machine
        'Sit on the leg press machine with back against the pad.',
        'Place feet on the platform shoulder-width apart.',
        'Release the safety handles.',
        'Lower the weight by bending your knees to 90 degrees.',
        'Press through your heels to return to starting position.',
      ],
      14: [ // Bulgarian Split Squat
        'Stand 2-3 feet in front of a bench or elevated surface.',
        'Place the top of one foot behind you on the bench.',
        'Lower into a lunge position on your front leg.',
        'Keep most of your weight on your front foot.',
        'Push through your front heel to return to starting position.',
      ],
      15: [ // Calf Raise
        'Stand with the balls of your feet on a raised surface.',
        'Let your heels drop below the level of your toes.',
        'Rise up on your toes as high as possible.',
        'Hold for a moment at the top.',
        'Slowly lower back to the starting position.',
      ],
      16: [ // Glute Bridge
        'Lie on your back with knees bent and feet flat.',
        'Keep your arms at your sides for stability.',
        'Squeeze your glutes and lift your hips up.',
        'Form a straight line from knees to shoulders.',
        'Hold briefly then lower back down.',
      ],
      17: [ // Hamstring Curl
        'Lie face down on the hamstring curl machine.',
        'Position the pad just above your ankles.',
        'Curl your heels towards your glutes.',
        'Squeeze your hamstrings at the top.',
        'Slowly lower back to starting position.',
      ],
      18: [ // Step Up
        'Stand in front of a sturdy bench or step.',
        'Step up with one foot, placing entire foot on surface.',
        'Drive through your heel to lift your body up.',
        'Step down with control.',
        'Complete reps on one side before switching.',
      ],
      19: [ // Wall Sit
        'Stand with your back against a wall.',
        'Walk your feet out and slide down the wall.',
        'Lower until your thighs are parallel to the floor.',
        'Keep your knees at 90-degree angles.',
        'Hold this position for the desired time.',
      ],
      20: [ // Sumo Squat
        'Stand with feet wider than shoulder-width apart.',
        'Turn your toes out at a 45-degree angle.',
        'Lower down keeping your knees tracking over your toes.',
        'Keep your chest up and core engaged.',
        'Drive through your heels to return to standing.',
      ],
      21: [ // Tricep Dips
        'Sit on the edge of a bench with hands beside your thighs.',
        'Slide forward off the bench supporting your weight with your arms.',
        'Lower your body by bending your elbows.',
        'Descend until your arms are at 90-degree angles.',
        'Push back up to starting position.',
      ],
      22: [ // Bicep Curl
        'Stand with feet hip-width apart, holding weights.',
        'Keep your elbows close to your sides.',
        'Curl the weights up towards your shoulders.',
        'Squeeze your biceps at the top.',
        'Slowly lower the weights back to starting position.',
      ],
      23: [ // Tricep Pushdown
        'Stand at a cable machine with a high pulley.',
        'Grip the bar with palms facing down.',
        'Keep your elbows at your sides.',
        'Push the bar down until your arms are fully extended.',
        'Slowly return to starting position.',
      ],
      24: [ // Hammer Curl
        'Hold dumbbells with a neutral grip (palms facing each other).',
        'Keep your elbows close to your sides.',
        'Curl the weights up without rotating your wrists.',
        'Squeeze your biceps at the top.',
        'Lower with control to starting position.',
      ],
      25: [ // Skullcrusher
        'Lie on a bench holding an EZ-bar above your chest.',
        'Keep your elbows stationary and pointing up.',
        'Lower the bar towards your forehead by bending elbows.',
        'Stop just above your forehead.',
        'Extend arms back to starting position.',
      ],
      26: [ // Cable Curl
        'Stand at a cable machine with low pulley.',
        'Grip the cable attachment with an underhand grip.',
        'Keep your elbows at your sides.',
        'Curl the cable up towards your chest.',
        'Slowly lower back to starting position.',
      ],
      27: [ // Concentration Curl
        'Sit on a bench with legs spread apart.',
        'Hold a dumbbell in one hand.',
        'Rest your elbow against your inner thigh.',
        'Curl the weight up towards your shoulder.',
        'Lower with control and repeat.',
      ],
      28: [ // Overhead Tricep Extension
        'Stand or sit holding a dumbbell above your head.',
        'Keep your elbows pointing forward.',
        'Lower the weight behind your head by bending elbows.',
        'Keep your upper arms stationary.',
        'Extend back to starting position.',
      ],
      29: [ // EZ-Bar Curl
        'Stand holding an EZ-bar with an underhand grip.',
        'Keep your elbows close to your sides.',
        'Curl the bar up towards your chest.',
        'Squeeze your biceps at the top.',
        'Lower the bar with control.',
      ],
      30: [ // Reverse Curl
        'Hold a barbell or dumbbells with an overhand grip.',
        'Keep your elbows at your sides.',
        'Curl the weight up towards your shoulders.',
        'Focus on engaging your forearms.',
        'Lower back to starting position slowly.',
      ],
      31: [ // Pull Up
        'Hang from a pull-up bar with palms facing away.',
        'Start with arms fully extended.',
        'Pull your body up until your chin clears the bar.',
        'Focus on using your back muscles.',
        'Lower yourself with control to starting position.',
      ],
      32: [ // Lat Pulldown
        'Sit at a lat pulldown machine.',
        'Grip the bar wider than shoulder-width.',
        'Pull the bar down to your upper chest.',
        'Squeeze your shoulder blades together.',
        'Slowly return the bar to starting position.',
      ],
      33: [ // Seated Row
        'Sit at a cable row machine with feet on footrests.',
        'Grip the handle with both hands.',
        'Pull the handle towards your abdomen.',
        'Squeeze your shoulder blades together.',
        'Slowly return to starting position.',
      ],
      34: [ // Bent Over Row
        'Stand with feet hip-width apart holding a barbell.',
        'Hinge at hips and bend forward with straight back.',
        'Pull the bar towards your lower chest.',
        'Squeeze your shoulder blades together.',
        'Lower the bar with control.',
      ],
      35: [ // Deadlift
        'Stand with feet hip-width apart, bar over mid-foot.',
        'Grip the bar just outside your legs.',
        'Keep your chest up and back straight.',
        'Drive through your heels to lift the bar.',
        'Stand tall then lower the bar with control.',
      ],
      36: [ // T-Bar Row
        'Straddle a T-bar with feet shoulder-width apart.',
        'Bend at hips and knees, keeping back straight.',
        'Grip the handles with both hands.',
        'Pull the bar towards your chest.',
        'Lower with control to starting position.',
      ],
      37: [ // Inverted Row
        'Lie under a barbell set at waist height.',
        'Grip the bar with hands shoulder-width apart.',
        'Keep your body in a straight line.',
        'Pull your chest up to the bar.',
        'Lower yourself back down with control.',
      ],
      38: [ // Superman
        'Lie face down with arms extended overhead.',
        'Keep your neck in neutral position.',
        'Simultaneously lift your chest and legs off the ground.',
        'Hold for a moment at the top.',
        'Lower back down with control.',
      ],
      39: [ // Resistance Band Row
        'Sit with legs extended, resistance band around feet.',
        'Hold handles with arms extended forward.',
        'Pull handles back towards your abdomen.',
        'Squeeze shoulder blades together.',
        'Slowly return to starting position.',
      ],
      40: [ // Single Arm Dumbbell Row
        'Place one knee and hand on a bench for support.',
        'Hold a dumbbell in your free hand.',
        'Pull the weight up to your side.',
        'Squeeze your back muscles at the top.',
        'Lower the weight with control.',
      ],
      41: [ // Crunch
        'Lie on your back with knees bent.',
        'Place hands behind your head or across chest.',
        'Lift your shoulders off the ground.',
        'Contract your abdominal muscles.',
        'Lower back down without fully relaxing.',
      ],
      42: [ // Plank
        'Start in a push-up position on your forearms.',
        'Keep your body in a straight line.',
        'Engage your core and glutes.',
        'Hold the position while breathing normally.',
        'Avoid letting your hips sag or pike up.',
      ],
      43: [ // Bicycle Crunch
        'Lie on your back with hands behind your head.',
        'Lift your shoulders off the ground.',
        'Bring one knee towards your chest while rotating torso.',
        'Touch elbow to opposite knee.',
        'Alternate sides in a pedaling motion.',
      ],
      44: [ // Leg Raise
        'Lie on your back with arms at your sides.',
        'Keep your legs straight or slightly bent.',
        'Lift your legs up towards the ceiling.',
        'Raise until hips come slightly off the ground.',
        'Lower legs with control without touching ground.',
      ],
      45: [ // Russian Twist
        'Sit with knees bent and feet off the ground.',
        'Lean back slightly while keeping chest up.',
        'Hold a weight or medicine ball.',
        'Rotate your torso from side to side.',
        'Keep your core engaged throughout.',
      ],
      46: [ // Mountain Climber
        'Start in a push-up position.',
        'Keep your core engaged and body straight.',
        'Bring one knee towards your chest.',
        'Quickly switch legs like running in place.',
        'Maintain steady rhythm and breathing.',
      ],
      47: [ // V-Up
        'Lie on your back with arms extended overhead.',
        'Keep your legs straight.',
        'Simultaneously lift your torso and legs.',
        'Touch your hands to your feet at the top.',
        'Lower back down with control.',
      ],
      48: [ // Flutter Kicks
        'Lie on your back with hands under your lower back.',
        'Lift your legs slightly off the ground.',
        'Keep legs straight and alternate small kicks.',
        'Maintain constant tension in your core.',
        'Keep movements controlled and steady.',
      ],
      49: [ // Reverse Crunch
        'Lie on your back with knees bent at 90 degrees.',
        'Place arms at your sides for support.',
        'Lift your hips off the ground towards your chest.',
        'Contract your lower abdominals.',
        'Lower back down with control.',
      ],
      50: [ // Hanging Knee Raise
        'Hang from a pull-up bar with arms extended.',
        'Keep your shoulders engaged and active.',
        'Lift your knees towards your chest.',
        'Contract your core muscles.',
        'Lower your legs with control.',
      ],
      51: [ // Shoulder Press
        'Stand or sit holding dumbbells at shoulder height.',
        'Keep your core engaged and back straight.',
        'Press the weights straight up overhead.',
        'Avoid arching your back.',
        'Lower the weights back to shoulder height.',
      ],
      52: [ // Dumbbell Lateral Raise
        'Stand with dumbbells at your sides.',
        'Keep a slight bend in your elbows.',
        'Raise the weights out to your sides.',
        'Lift until arms are parallel to the floor.',
        'Lower the weights with control.',
      ],
      53: [ // Front Raise
        'Stand with dumbbells in front of your thighs.',
        'Keep arms straight with slight elbow bend.',
        'Raise one or both weights forward.',
        'Lift until arms are parallel to the floor.',
        'Lower the weights back down slowly.',
      ],
      54: [ // Arnold Press
        'Start with dumbbells at chest level, palms facing you.',
        'As you press up, rotate your palms forward.',
        'Press the weights overhead.',
        'Reverse the motion on the way down.',
        'Rotate palms back to face you at bottom.',
      ],
      55: [ // Rear Delt Fly
        'Bend forward at hips holding dumbbells.',
        'Keep arms slightly bent throughout movement.',
        'Raise weights out to your sides.',
        'Squeeze your shoulder blades together.',
        'Lower weights back to starting position.',
      ],
      56: [ // Upright Row
        'Stand holding a barbell with narrow grip.',
        'Keep the bar close to your body.',
        'Pull the bar up towards your chin.',
        'Lead with your elbows.',
        'Lower the bar back down slowly.',
      ],
      57: [ // Face Pull
        'Set cable at face height with rope attachment.',
        'Grip rope with thumbs facing up.',
        'Pull rope towards your face.',
        'Separate handles as you pull back.',
        'Squeeze shoulder blades together.',
      ],
      58: [ // Push Press
        'Start with weight at shoulder height.',
        'Slightly bend knees and hips.',
        'Explosively drive through legs and press weight up.',
        'Use leg drive to assist the press.',
        'Lower weight back to shoulders with control.',
      ],
      59: [ // Pike Push Up
        'Start in downward dog position.',
        'Walk feet closer to hands to increase difficulty.',
        'Lower the top of your head towards the ground.',
        'Press back up to starting position.',
        'Keep core engaged throughout movement.',
      ],
      60: [ // Seated Barbell Press
        'Sit on a bench with back support.',
        'Hold barbell at shoulder height.',
        'Press the bar straight up overhead.',
        'Keep core engaged and back against pad.',
        'Lower bar back to shoulder height.',
      ],
      61: [ // Running
        'Start with a proper warm-up and stretching.',
        'Maintain good posture with chest up and shoulders relaxed.',
        'Land mid-foot with each step to reduce impact.',
        'Keep your arms at 90-degree angles and swing naturally.',
        'Breathe rhythmically and maintain a steady pace.',
      ],
      62: [ // Cycling
        'Adjust seat height so your leg is almost straight at bottom of pedal stroke.',
        'Keep your back straight and shoulders relaxed.',
        'Maintain a steady cadence of 80-100 RPM.',
        'Use proper cycling shoes for better power transfer.',
        'Stay hydrated and take breaks as needed.',
      ],
      63: [ // Jump Rope
        'Hold handles at hip level with elbows close to body.',
        'Jump on the balls of your feet with slight knee bend.',
        'Keep jumps low and controlled, about 1-2 inches off ground.',
        'Maintain rhythm and timing with rope rotation.',
        'Start with basic jumps before trying advanced moves.',
      ],
      64: [ // Elliptical
        'Stand tall with shoulders back and core engaged.',
        'Keep your feet flat on the foot pedals.',
        'Use both forward and backward motion for variety.',
        'Don\'t lean on the handles - use them for balance only.',
        'Maintain a steady pace and resistance level.',
      ],
      65: [ // Rowing
        'Start with legs extended, arms straight, leaning forward.',
        'Drive back with legs first, then lean back, then pull arms.',
        'Keep your back straight and core engaged throughout.',
        'Return to starting position in reverse order.',
        'Focus on smooth, fluid motion rather than speed.',
      ],
      66: [ // Burpees
        'Start standing, then drop into a squat position.',
        'Place hands on ground and kick feet back to plank position.',
        'Perform a push-up (optional), then jump feet back to squat.',
        'Explosively jump up with arms overhead.',
        'Land softly and immediately go into next repetition.',
      ],
      67: [ // High Knees
        'Stand in place with feet hip-width apart.',
        'Run in place, bringing knees up to waist level.',
        'Pump your arms as if running normally.',
        'Stay on the balls of your feet.',
        'Maintain good posture and engage your core.',
      ],
      68: [ // Jumping Jacks
        'Start standing with feet together and arms at sides.',
        'Jump feet apart while raising arms overhead.',
        'Jump back to starting position with arms down.',
        'Keep movements controlled and rhythmic.',
        'Land softly to reduce impact on joints.',
      ],
      69: [ // Stair Climbing
        'Step up with your whole foot, not just toes.',
        'Keep your back straight and core engaged.',
        'Use handrails for balance if needed, but don\'t rely on them.',
        'Maintain a steady pace and rhythm.',
        'Take breaks as needed to maintain proper form.',
      ],
      70: [ // Swimming
        'Start with proper breathing technique and stroke form.',
        'Keep your body horizontal and streamlined in the water.',
        'Use your core to maintain body position.',
        'Coordinate arm and leg movements for efficient swimming.',
        'Start with shorter distances and build endurance gradually.',
      ],
    };

    // Tips for each exercise - Safety and form guidance for all 60 exercises
    final Map<int, List<String>> exerciseTips = {
      1: [ // Push Up
        'Keep your core tight throughout the movement',
        'Don\'t let your hips sag or pike up',
        'Breathe in on the way down, out on the way up',
        'Start with modified push-ups if needed',
      ],
      2: [ // Barbell Bench Press
        'Always use a spotter when lifting heavy',
        'Keep your shoulder blades pulled back',
        'Don\'t bounce the bar off your chest',
        'Use a full range of motion',
      ],
      3: [ // Dumbbell Flyes
        'Don\'t lower weights too far to avoid shoulder injury',
        'Keep elbows slightly bent throughout',
        'Focus on chest squeeze at the top',
        'Use lighter weights to maintain control',
      ],
      4: [ // Incline Push Up
        'Choose height based on your fitness level',
        'Keep your body rigid like a plank',
        'Progress to regular push-ups over time',
        'Focus on controlled movement',
      ],
      5: [ // Decline Bench Press
        'Secure your feet properly on the bench',
        'Use lighter weight than flat bench press',
        'Don\'t arch your back excessively',
        'Control the weight throughout',
      ],
      6: [ // Chest Dips
        'Warm up shoulders thoroughly before starting',
        'Don\'t dip too low to avoid shoulder injury',
        'Keep elbows slightly forward',
        'Stop if you feel shoulder pain',
      ],
      7: [ // Cable Crossover
        'Use smooth, controlled movements',
        'Don\'t use excessive weight',
        'Keep core engaged for stability',
        'Focus on the muscle connection',
      ],
      8: [ // Machine Chest Press
        'Adjust seat for proper alignment',
        'Don\'t lock elbows at extension',
        'Keep back pressed against pad',
        'Use full range of motion',
      ],
      9: [ // Plyometric Push Up
        'Land softly to protect wrists',
        'Build up power gradually',
        'Don\'t sacrifice form for speed',
        'Rest adequately between sets',
      ],
      10: [ // Close-Grip Push Up
        'Keep elbows close to your body',
        'Focus on tricep engagement',
        'Don\'t flare elbows out wide',
        'Progress slowly to build strength',
      ],
      11: [ // Squat
        'Keep your weight on your heels',
        'Don\'t let your knees cave inward',
        'Start with bodyweight before adding load',
        'Warm up thoroughly before heavy squats',
      ],
      12: [ // Lunges
        'Don\'t let front knee go past toes',
        'Keep torso upright throughout',
        'Step back to starting position carefully',
        'Use rail for balance if needed',
      ],
      13: [ // Leg Press Machine
        'Don\'t lower weight too far',
        'Keep knees aligned with toes',
        'Don\'t lock knees at the top',
        'Use safety stops appropriately',
      ],
      14: [ // Bulgarian Split Squat
        'Keep most weight on front leg',
        'Don\'t push off back foot',
        'Maintain balance throughout movement',
        'Start with bodyweight only',
      ],
      15: [ // Calf Raise
        'Use full range of motion',
        'Control the movement both ways',
        'Hold briefly at the top',
        'Don\'t bounce at the bottom',
      ],
      16: [ // Glute Bridge
        'Squeeze glutes at the top',
        'Don\'t overarch your back',
        'Keep core engaged',
        'Focus on glute activation',
      ],
      17: [ // Hamstring Curl
        'Don\'t swing or use momentum',
        'Control the lowering phase',
        'Keep hips pressed down',
        'Adjust pad position properly',
      ],
      18: [ // Step Up
        'Use a sturdy, stable platform',
        'Place entire foot on step',
        'Control the descent',
        'Don\'t push off trailing leg',
      ],
      19: [ // Wall Sit
        'Keep knees at 90 degrees',
        'Don\'t let knees cave inward',
        'Breathe normally during hold',
        'Build up time gradually',
      ],
      20: [ // Sumo Squat
        'Point toes out at 45 degrees',
        'Keep knees tracking over toes',
        'Don\'t lean forward',
        'Feel stretch in inner thighs',
      ],
      21: [ // Tricep Dips
        'Keep elbows pointing back',
        'Don\'t dip too low',
        'Engage core for stability',
        'Avoid if you have shoulder issues',
      ],
      22: [ // Bicep Curl
        'Don\'t swing or use momentum',
        'Focus on slow, controlled movements',
        'Keep your wrists straight',
        'Vary your grip for different muscle activation',
      ],
      23: [ // Tricep Pushdown
        'Keep elbows stationary at sides',
        'Don\'t lean forward or back',
        'Focus on tricep contraction',
        'Control the weight up and down',
      ],
      24: [ // Hammer Curl
        'Keep neutral wrist position',
        'Don\'t rotate wrists during movement',
        'Focus on bicep and forearm engagement',
        'Control the eccentric phase',
      ],
      25: [ // Skullcrusher
        'Keep elbows pointing up throughout',
        'Don\'t let elbows flare out',
        'Use controlled movements',
        'Start with lighter weight',
      ],
      26: [ // Cable Curl
        'Keep elbows at your sides',
        'Don\'t swing your body',
        'Focus on bicep contraction',
        'Use smooth, controlled motion',
      ],
      27: [ // Concentration Curl
        'Keep elbow pressed against thigh',
        'Don\'t use momentum',
        'Focus on peak contraction',
        'Control the lowering phase',
      ],
      28: [ // Overhead Tricep Extension
        'Keep elbows pointing forward',
        'Don\'t let elbows flare out',
        'Control the weight behind head',
        'Keep core engaged',
      ],
      29: [ // EZ-Bar Curl
        'Use natural grip with EZ-bar',
        'Don\'t swing the weight',
        'Keep elbows at sides',
        'Focus on bicep squeeze',
      ],
      30: [ // Reverse Curl
        'Keep overhand grip throughout',
        'Focus on forearm engagement',
        'Use lighter weight than regular curls',
        'Control both phases of movement',
      ],
      31: [ // Pull Up
        'Use full range of motion',
        'Don\'t swing or kip',
        'Keep shoulders engaged at bottom',
        'Build up to full pull-ups gradually',
      ],
      32: [ // Lat Pulldown
        'Pull to upper chest, not neck',
        'Lean back slightly',
        'Keep chest up and shoulders back',
        'Focus on lat engagement',
      ],
      33: [ // Seated Row
        'Keep chest up and shoulders back',
        'Don\'t round your back',
        'Pull handle to lower chest',
        'Control the return phase',
      ],
      34: [ // Bent Over Row
        'Keep back straight and core tight',
        'Don\'t use excessive weight',
        'Pull bar to lower chest/upper abdomen',
        'Keep knees slightly bent',
      ],
      35: [ // Deadlift
        'Keep bar close to your body',
        'Don\'t round your back',
        'Drive through heels',
        'Learn proper form before adding weight',
      ],
      36: [ // T-Bar Row
        'Keep chest up and back straight',
        'Don\'t use excessive weight',
        'Pull handle to chest',
        'Control the negative phase',
      ],
      37: [ // Inverted Row
        'Keep body in straight line',
        'Adjust bar height for difficulty',
        'Pull chest to bar',
        'Control the lowering phase',
      ],
      38: [ // Superman
        'Don\'t lift too high',
        'Keep movements controlled',
        'Focus on back muscle engagement',
        'Keep neck in neutral position',
      ],
      39: [ // Resistance Band Row
        'Keep tension in band throughout',
        'Don\'t let band snap back',
        'Pull handles to sides of torso',
        'Choose appropriate band resistance',
      ],
      40: [ // Single Arm Dumbbell Row
        'Keep supporting arm straight',
        'Don\'t rotate torso',
        'Pull weight to hip area',
        'Keep core engaged for stability',
      ],
      41: [ // Crunch
        'Don\'t pull on your neck',
        'Focus on ab contraction',
        'Keep lower back on ground',
        'Breathe out as you crunch up',
      ],
      42: [ // Plank
        'Quality over quantity - maintain perfect form',
        'Start with shorter holds and progress gradually',
        'Keep your neck in neutral position',
        'Breathe normally, don\'t hold your breath',
      ],
      43: [ // Bicycle Crunch
        'Don\'t pull on your neck',
        'Focus on bringing elbow to knee',
        'Keep constant tension in abs',
        'Control the movement speed',
      ],
      44: [ // Leg Raise
        'Don\'t swing legs up',
        'Keep lower back pressed down',
        'Control the lowering phase',
        'Bend knees if too difficult',
      ],
      45: [ // Russian Twist
        'Keep chest up throughout',
        'Don\'t round your back',
        'Control the rotation speed',
        'Keep core engaged',
      ],
      46: [ // Mountain Climber
        'Keep hips level with shoulders',
        'Don\'t let hips pike up',
        'Maintain steady rhythm',
        'Keep core tight throughout',
      ],
      47: [ // V-Up
        'Keep movements controlled',
        'Don\'t use momentum',
        'Focus on ab contraction',
        'Modify by bending knees if needed',
      ],
      48: [ // Flutter Kicks
        'Keep lower back pressed down',
        'Make small, controlled movements',
        'Keep legs straight',
        'Maintain constant core tension',
      ],
      49: [ // Reverse Crunch
        'Don\'t swing legs up',
        'Focus on lower ab contraction',
        'Keep knees at 90 degrees',
        'Control the movement',
      ],
      50: [ // Hanging Knee Raise
        'Don\'t swing or use momentum',
        'Keep shoulders engaged',
        'Focus on controlled movement',
        'Build grip strength gradually',
      ],
      51: [ // Shoulder Press
        'Don\'t arch back excessively',
        'Keep core engaged',
        'Press weights straight up',
        'Don\'t lock elbows at top',
      ],
      52: [ // Dumbbell Lateral Raise
        'Don\'t use heavy weights',
        'Keep slight bend in elbows',
        'Don\'t lift above shoulder height',
        'Control the lowering phase',
      ],
      53: [ // Front Raise
        'Don\'t swing or use momentum',
        'Keep core engaged',
        'Don\'t lift above shoulder height',
        'Use lighter weights for control',
      ],
      54: [ // Arnold Press
        'Rotate palms smoothly',
        'Don\'t use excessive weight',
        'Keep core tight',
        'Control the rotation',
      ],
      55: [ // Rear Delt Fly
        'Keep slight bend in elbows',
        'Don\'t use momentum',
        'Focus on rear delt squeeze',
        'Keep chest up',
      ],
      56: [ // Upright Row
        'Don\'t pull too high to avoid impingement',
        'Keep bar close to body',
        'Lead with elbows',
        'Stop if you feel shoulder pain',
      ],
      57: [ // Face Pull
        'Pull rope apart at face level',
        'Keep elbows high',
        'Focus on rear delt and rhomboid squeeze',
        'Don\'t use excessive weight',
      ],
      58: [ // Push Press
        'Use legs to generate power',
        'Keep weight balanced overhead',
        'Don\'t lean back excessively',
        'Control the lowering phase',
      ],
      59: [ // Pike Push Up
        'Keep legs straight if possible',
        'Don\'t go too deep initially',
        'Focus on shoulder engagement',
        'Progress difficulty gradually',
      ],
      60: [ // Seated Barbell Press
        'Keep back against pad',
        'Don\'t arch back excessively',
        'Press bar straight up',
        'Use safety catches if available',
      ],
      61: [ // Running
        'Start with shorter distances and gradually increase',
        'Invest in good running shoes for proper support',
        'Listen to your body and don\'t push through pain',
        'Stay hydrated and fuel properly before and after',
      ],
      62: [ // Cycling
        'Adjust bike settings for proper fit and comfort',
        'Start with shorter sessions and build endurance',
        'Use proper cycling form to prevent injury',
        'Vary your intensity with intervals and steady state',
      ],
      63: [ // Jump Rope
        'Start with basic jumps before trying advanced moves',
        'Use proper rope length - handles should reach armpits',
        'Jump on a forgiving surface to reduce impact',
        'Focus on rhythm and timing rather than speed initially',
      ],
      64: [ // Elliptical
        'Don\'t lean on the handles - use them for balance only',
        'Vary your resistance and incline for different workouts',
        'Keep your feet flat on the pedals throughout',
        'Use both forward and backward motion for variety',
      ],
      65: [ // Rowing
        'Focus on proper form over speed or distance',
        'Use your legs for power, not just your arms',
        'Keep your back straight and core engaged',
        'Start with shorter sessions to build endurance',
      ],
      66: [ // Burpees
        'Start with modified versions if needed',
        'Focus on form and control over speed',
        'Take breaks between sets to maintain quality',
        'Land softly to protect your joints',
      ],
      67: [ // High Knees
        'Keep your core engaged throughout the movement',
        'Stay on the balls of your feet',
        'Maintain good posture and don\'t lean back',
        'Start with slower pace and increase speed gradually',
      ],
      68: [ // Jumping Jacks
        'Land softly to reduce impact on joints',
        'Keep movements controlled and rhythmic',
        'Maintain good posture throughout',
        'Start with slower pace and increase gradually',
      ],
      69: [ // Stair Climbing
        'Use proper footwear with good support',
        'Take one step at a time initially',
        'Keep your back straight and core engaged',
        'Use handrails for balance but don\'t rely on them',
      ],
      70: [ // Swimming
        'Start with proper breathing technique',
        'Take swimming lessons if you\'re a beginner',
        'Start with shorter distances and build up',
        'Use different strokes to work different muscle groups',
      ],
    };

    // Equipment for each exercise - What you need for safe execution
    final Map<int, List<String>> exerciseEquipment = {
      1: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Push Up
      2: ['Barbell', 'Bench', 'Weight Plates', 'Safety Collars'], // Barbell Bench Press
      3: ['Dumbbells', 'Flat Bench'], // Dumbbell Flyes
      4: ['Elevated Surface (Bench/Step)', 'Optional: Exercise Mat'], // Incline Push Up
      5: ['Barbell', 'Decline Bench', 'Weight Plates', 'Safety Collars'], // Decline Bench Press
      6: ['Parallel Bars', 'or Dip Station'], // Chest Dips
      7: ['Cable Machine', 'High Pulley', 'Handle Attachments'], // Cable Crossover
      8: ['Chest Press Machine'], // Machine Chest Press
      9: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Plyometric Push Up
      10: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Close-Grip Push Up
      11: ['None (Bodyweight)', 'Optional: Barbell & Weights'], // Squat
      12: ['None (Bodyweight)', 'Optional: Dumbbells'], // Lunges
      13: ['Leg Press Machine'], // Leg Press Machine
      14: ['Bench or Step', 'Optional: Dumbbells'], // Bulgarian Split Squat
      15: ['Raised Platform', 'Optional: Dumbbells'], // Calf Raise
      16: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Glute Bridge
      17: ['Hamstring Curl Machine'], // Hamstring Curl
      18: ['Sturdy Bench or Step'], // Step Up
      19: ['Wall'], // Wall Sit
      20: ['None (Bodyweight)', 'Optional: Dumbbells'], // Sumo Squat
      21: ['Bench', 'or Parallel Bars'], // Tricep Dips
      22: ['Dumbbells', 'or Barbell', 'or Resistance Bands'], // Bicep Curl
      23: ['Cable Machine', 'High Pulley', 'Bar Attachment'], // Tricep Pushdown
      24: ['Dumbbells'], // Hammer Curl
      25: ['EZ-Bar or Dumbbells', 'Bench'], // Skullcrusher
      26: ['Cable Machine', 'Low Pulley', 'Bar Attachment'], // Cable Curl
      27: ['Dumbbell', 'Bench'], // Concentration Curl
      28: ['Dumbbell', 'Optional: Bench'], // Overhead Tricep Extension
      29: ['EZ-Bar'], // EZ-Bar Curl
      30: ['Barbell or Dumbbells'], // Reverse Curl
      31: ['Pull-up Bar'], // Pull Up
      32: ['Lat Pulldown Machine', 'Wide Grip Bar'], // Lat Pulldown
      33: ['Cable Row Machine', 'Seated Row Attachment'], // Seated Row
      34: ['Barbell', 'Weight Plates'], // Bent Over Row
      35: ['Barbell', 'Weight Plates', 'Optional: Lifting Straps'], // Deadlift
      36: ['T-Bar Row Machine', 'or Landmine Setup'], // T-Bar Row
      37: ['Barbell in Squat Rack', 'Set at Waist Height'], // Inverted Row
      38: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Superman
      39: ['Resistance Band'], // Resistance Band Row
      40: ['Dumbbell', 'Bench for Support'], // Single Arm Dumbbell Row
      41: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Crunch
      42: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Plank
      43: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Bicycle Crunch
      44: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Leg Raise
      45: ['Optional: Medicine Ball or Weight'], // Russian Twist
      46: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Mountain Climber
      47: ['None (Bodyweight)', 'Optional: Exercise Mat'], // V-Up
      48: ['None (Bodyweight)', 'Exercise Mat Recommended'], // Flutter Kicks
      49: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Reverse Crunch
      50: ['Pull-up Bar'], // Hanging Knee Raise
      51: ['Dumbbells', 'Optional: Bench with Back Support'], // Shoulder Press
      52: ['Dumbbells'], // Dumbbell Lateral Raise
      53: ['Dumbbells'], // Front Raise
      54: ['Dumbbells'], // Arnold Press
      55: ['Dumbbells'], // Rear Delt Fly
      56: ['Barbell'], // Upright Row
      57: ['Cable Machine', 'Rope Attachment'], // Face Pull
      58: ['Barbell or Dumbbells'], // Push Press
      59: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Pike Push Up
      60: ['Barbell', 'Bench with Back Support'], // Seated Barbell Press
      61: ['Running Shoes', 'Treadmill (Optional)'], // Running
      62: ['Stationary Bike', 'Cycling Shoes (Optional)'], // Cycling
      63: ['Jump Rope'], // Jump Rope
      64: ['Elliptical Machine'], // Elliptical
      65: ['Rowing Machine'], // Rowing
      66: ['None (Bodyweight)', 'Optional: Exercise Mat'], // Burpees
      67: ['None (Bodyweight)'], // High Knees
      68: ['None (Bodyweight)'], // Jumping Jacks
      69: ['Stair Machine', 'Stairs'], // Stair Climbing
      70: ['Swimming Pool', 'Swimsuit'], // Swimming
    };

    // Insert instructions
    for (final exerciseId in exerciseInstructions.keys) {
      final instructions = exerciseInstructions[exerciseId]!;
      for (int i = 0; i < instructions.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'instruction',
          'content': instructions[i],
          'order_index': i,
        });
      }
    }

    // Insert tips
    for (final exerciseId in exerciseTips.keys) {
      final tips = exerciseTips[exerciseId]!;
      for (int i = 0; i < tips.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'tip',
          'content': tips[i],
          'order_index': i,
        });
      }
    }

    // Insert equipment
    for (final exerciseId in exerciseEquipment.keys) {
      final equipment = exerciseEquipment[exerciseId]!;
      for (int i = 0; i < equipment.length; i++) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'equipment',
          'content': equipment[i],
          'order_index': i,
        });
      }
    }

    // For exercises without specific data, add default instructions, tips, and equipment
    for (int exerciseId = 1; exerciseId <= 70; exerciseId++) {
      // Check if exercise has instructions, if not add default ones
      if (!exerciseInstructions.containsKey(exerciseId)) {
        final defaultInstructions = [
          'Position yourself properly for the exercise.',
          'Engage your core and maintain proper form.',
          'Perform the movement slowly and controlled.',
          'Focus on the targeted muscle groups.',
          'Complete the desired number of repetitions.',
        ];
        for (int i = 0; i < defaultInstructions.length; i++) {
          await db.insert('ExerciseDetail', {
            'exercise_id': exerciseId,
            'type': 'instruction',
            'content': defaultInstructions[i],
            'order_index': i,
          });
        }
      }

      // Check if exercise has tips, if not add default ones
      if (!exerciseTips.containsKey(exerciseId)) {
        final defaultTips = [
          'Focus on proper form over speed or weight',
          'Warm up before exercising',
          'Listen to your body and stop if you feel pain',
          'Progress gradually to avoid injury',
        ];
        for (int i = 0; i < defaultTips.length; i++) {
          await db.insert('ExerciseDetail', {
            'exercise_id': exerciseId,
            'type': 'tip',
            'content': defaultTips[i],
            'order_index': i,
          });
        }
      }

      // Check if exercise has equipment, if not add default
      if (!exerciseEquipment.containsKey(exerciseId)) {
        await db.insert('ExerciseDetail', {
          'exercise_id': exerciseId,
          'type': 'equipment',
          'content': 'Check with trainer for equipment needed',
          'order_index': 0,
        });
      }
    }
  }
}
