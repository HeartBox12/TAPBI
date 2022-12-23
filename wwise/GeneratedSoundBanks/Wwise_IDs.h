/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Audiokinetic Wwise generated include file. Do not edit.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////

#ifndef __WWISE_IDS_H__
#define __WWISE_IDS_H__

#include <AK/SoundEngine/Common/AkTypes.h>

namespace AK
{
    namespace EVENTS
    {
        static const AkUniqueID GAMEOVER = 4158285989U;
        static const AkUniqueID PLAY = 1256202815U;
        static const AkUniqueID RESPAWN = 4279841335U;
        static const AkUniqueID SETSTATEDEAD = 2167267996U;
        static const AkUniqueID SETSTATEINGAME = 3534336897U;
        static const AkUniqueID SETSTATEPAUSED = 4091358244U;
        static const AkUniqueID SETSTATEPHASE1 = 1993696620U;
        static const AkUniqueID SETSTATEPHASE2 = 1993696623U;
        static const AkUniqueID SETSTATEPHASE3 = 1993696622U;
        static const AkUniqueID STOPALL = 3086540886U;
    } // namespace EVENTS

    namespace STATES
    {
        namespace GAMESTATE
        {
            static const AkUniqueID GROUP = 4091656514U;

            namespace STATE
            {
                static const AkUniqueID INGAME = 984691642U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID PAUSED = 319258907U;
            } // namespace STATE
        } // namespace GAMESTATE

        namespace PLAYERSTATE
        {
            static const AkUniqueID GROUP = 3285234865U;

            namespace STATE
            {
                static const AkUniqueID DEAD = 2044049779U;
                static const AkUniqueID NONE = 748895195U;
                static const AkUniqueID PHASE1 = 3630028971U;
                static const AkUniqueID PHASE2 = 3630028968U;
                static const AkUniqueID PHASE3 = 3630028969U;
            } // namespace STATE
        } // namespace PLAYERSTATE

    } // namespace STATES

    namespace GAME_PARAMETERS
    {
        static const AkUniqueID MUSICVOLUME = 2346531308U;
    } // namespace GAME_PARAMETERS

    namespace BANKS
    {
        static const AkUniqueID INIT = 1355168291U;
        static const AkUniqueID MUSICSOUNDBANK = 3427827313U;
    } // namespace BANKS

    namespace BUSSES
    {
        static const AkUniqueID MASTER_AUDIO_BUS = 3803692087U;
    } // namespace BUSSES

    namespace AUDIO_DEVICES
    {
        static const AkUniqueID NO_OUTPUT = 2317455096U;
        static const AkUniqueID SYSTEM = 3859886410U;
    } // namespace AUDIO_DEVICES

}// namespace AK

#endif // __WWISE_IDS_H__
